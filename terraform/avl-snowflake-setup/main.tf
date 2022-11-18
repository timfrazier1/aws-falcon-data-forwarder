data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

locals {
  db_name 		= length(var.db_name) > 0 ? var.db_name : "anvilogic"
  iam_role_name = length(var.iam_role_name) > 0 ? var.iam_role_name : "avl-snowflake-s3-integration-role-${random_id.uniq.hex}"
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.name
  pipeline_bucket_ids = [
    for bucket_arn in var.data_bucket_arns : element(split(":::", bucket_arn), 1)
  ]
  }

resource "snowflake_database" "anvilogic_db" {
  provider = snowflake.account_admin
  name     = var.db_name
}

resource "snowflake_warehouse" "task_warehouse" {
  provider = snowflake.account_admin
  name           = var.task_warehouse_name
  warehouse_size = var.task_warehouse_size

  auto_suspend = 60
  enable_query_acceleration = false
  query_acceleration_max_scale_factor = 0
}

resource "snowflake_warehouse" "detect_warehouse" {
  provider = snowflake.account_admin
  name           = var.detect_warehouse_name
  warehouse_size = var.detect_warehouse_size

  auto_suspend = 60
  enable_query_acceleration = false
  query_acceleration_max_scale_factor = 0
}

resource "snowflake_schema" "staging_schema" {
  provider = snowflake.account_admin
  database   = snowflake_database.anvilogic_db.name
  name       = var.staging_schema_name
  is_managed = false
}

resource "snowflake_schema" "data_source_schema" {
  provider = snowflake.account_admin
  database   = snowflake_database.anvilogic_db.name
  name       = var.data_source_schema_name
  is_managed = false
}

resource "snowflake_role" "avl_role" {
  provider = snowflake.security_admin
  name     = var.avl_role_name
}

resource "tls_private_key" "svc_key" {
  algorithm = "RSA"
  rsa_bits  = 2048
}

resource "snowflake_user" "avl_user" {
  provider = snowflake.security_admin
  name     = var.avl_user_name
  default_warehouse = snowflake_warehouse.detect_warehouse.name
  default_role      = snowflake_role.avl_role.name
  default_namespace = "${snowflake_database.anvilogic_db.name}.${snowflake_schema.data_source_schema.name}"
  rsa_public_key    = substr(tls_private_key.svc_key.public_key_pem, 27, 398)
}

resource "snowflake_role_grants" "avl_grants" {
  provider  = snowflake.security_admin
  role_name = snowflake_role.avl_role.name
  users     = [snowflake_user.avl_user.name]
}

resource "snowflake_database_grant" "grant" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.anvilogic_db.name
  privilege         = "USAGE"
  roles             = [snowflake_role.avl_role.name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "staging_grant" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.anvilogic_db.name
  schema_name       = snowflake_schema.staging_schema.name
  privilege         = "USAGE"
  roles             = [snowflake_role.avl_role.name]
  with_grant_option = false
}

resource "snowflake_schema_grant" "data_source_grant" {
  provider          = snowflake.security_admin
  database_name     = snowflake_database.anvilogic_db.name
  schema_name       = snowflake_schema.data_source_schema.name
  privilege         = "USAGE"
  roles             = [snowflake_role.avl_role.name]
  with_grant_option = false
}

resource "snowflake_warehouse_grant" "detect_warehouse_grant" {
  provider          = snowflake.security_admin
  warehouse_name    = snowflake_warehouse.detect_warehouse.name
  privilege         = "USAGE"
  roles             = [snowflake_role.avl_role.name]
  with_grant_option = false
}

resource "snowflake_warehouse_grant" "task_warehouse_grant" {
  provider          = snowflake.security_admin
  warehouse_name    = snowflake_warehouse.task_warehouse.name
  privilege         = "USAGE"
  roles             = [snowflake_role.avl_role.name]
  with_grant_option = false
}

resource "random_id" "uniq" {
  byte_length = 4
}

data "aws_iam_policy_document" "snowflake_storage_integration_assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [snowflake_storage_integration.s3_integration.storage_aws_iam_user_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values   = [snowflake_storage_integration.s3_integration.storage_aws_external_id] 
    }
  }
}

data "aws_iam_policy_document" "snowflake_storage_integration_access_policy" {
  version = "2012-10-17"

  dynamic "statement" {
    for_each = var.data_bucket_arns

    content {
      sid       = "S3ReadWritePerms${statement.key}"
      effect    = "Allow"
      resources = ["${statement.value}/*"]

      actions = [
        "s3:PutObject",
        "s3:GetObject",
        "s3:GetObjectVersion",
      ]
    }
  }

  dynamic "statement" {
    for_each = var.data_bucket_arns

    content {
      sid       = "S3ListPerms${statement.key}"
      effect    = "Allow"
      resources = [statement.value]

      actions = [
	"s3:ListBucket",
	"s3:GetBucketLocation"
	]

      condition {
        test     = "StringLike"
        variable = "s3:prefix"
        values   = ["*"]
      }
    }
  }


}

resource "aws_iam_role" "snowflake_storage_integration_iam_role" {
  name               = local.iam_role_name
  assume_role_policy = data.aws_iam_policy_document.snowflake_storage_integration_assume_role_policy.json
  tags               = var.tags
}

resource "aws_iam_role_policy" "snowflake_s3_reader_policy" {
  name = "snowflake-integration-s3-reader-policy"
  role = aws_iam_role.snowflake_storage_integration_iam_role.id

  policy 	     = data.aws_iam_policy_document.snowflake_storage_integration_access_policy.json
}

resource snowflake_storage_integration s3_integration {
  provider = snowflake.account_admin
  name    = var.storage_integration_name
  comment = "A storage integration created by Anvilogic through Terraform."
  type    = "EXTERNAL_STAGE"

  enabled = true

  storage_provider         = "S3"
  # storage_allowed_locations = ["s3://placeholder"]
  # storage_allowed_locations = ["s3://${var.s3_bucket_name}/"]
  storage_allowed_locations = [for bucket_id in local.pipeline_bucket_ids : "s3://${bucket_id}/"]

  # concat(
  #  ["s3://${aws_s3_bucket.geff_bucket.id}/"],
  #  [for bucket_id in local.pipeline_bucket_ids : "s3://${bucket_id}/"]
  #)
  storage_aws_role_arn     = "arn:aws:iam::${local.account_id}:role/${local.iam_role_name}"

  #   storage_blocked_locations = [""]
  #   storage_aws_object_acl    = "bucket-owner-full-control"

  # storage_aws_external_id  = [random_string.external_id.result]
  # storage_aws_iam_user_arn = "..."

  # azure_tenant_id
}



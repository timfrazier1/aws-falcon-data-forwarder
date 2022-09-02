
provider "aws" {
  region = "us-west-2"
}

resource "random_id" "uniq" {
  byte_length = 4
}

locals {
  crwd_logs_bucket_name        = (length(var.logs_bucket_name) > 0 ? var.logs_bucket_name : "${var.prefix}-fdr-logs-bucket-${random_id.uniq.hex}")
  lambda_code_bucket_name        = (length(var.lambda_bucket_name) > 0 ? var.lambda_bucket_name : "${var.prefix}-lambda-code-bucket-${random_id.uniq.hex}")
}

resource "aws_s3_bucket" "crwd-logs" {
  bucket = local.crwd_logs_bucket_name 
  force_destroy = true
  tags = {
    Name        = "Crowdstrike FDR Logs"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  count = var.snowpipe_sqs_queue_arn != "" ? 1 : 0
  bucket = aws_s3_bucket.crwd-logs.id

  queue {
    queue_arn		= var.snowpipe_sqs_queue_arn
    events		= ["s3:ObjectCreated:*"]
  }
}

resource "aws_s3_bucket_acl" "log_bucket_acl" {
  bucket = aws_s3_bucket.crwd-logs.id
  acl    = "private"
}

resource "aws_s3_bucket" "lambda-code" {
  bucket = local.lambda_code_bucket_name
  force_destroy = true
  tags = {
    Name        = "Lambda Function Code Bucket"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_acl" "code_bucket_acl" {
  bucket = aws_s3_bucket.lambda-code.id
  acl    = "private"
}

resource "aws_secretsmanager_secret" "crwd-secrets" {
  name = "${var.prefix}-CRWD-secrets-${random_id.uniq.hex}"
}

resource "aws_secretsmanager_secret_version" "crwd-access-keys" {
  secret_id     = aws_secretsmanager_secret.crwd-secrets.id
  secret_string = jsonencode(var.secret_map)
}

locals {
  iam_role_name = length(var.iam_role_name) > 0 ? var.iam_role_name : "avl-lambda-iam-${random_id.uniq.hex}"
}

resource "aws_iam_role" "lambda_iam_role" {
  name               = local.iam_role_name
  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
        "Effect": "Allow",
        "Principal": {
            "Service": "lambda.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
    }]
  })
}


resource "aws_iam_role_policy" "iam_policy_for_lamda_role" {
  name = "iam-lamba-policy"
  role = aws_iam_role.lambda_iam_role.id
  policy = data.aws_iam_policy_document.policy_document_for_lambda.json
}

data "aws_iam_policy_document" "policy_document_for_lambda" {
  statement {
    sid       = "getSecrets"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [resource.aws_secretsmanager_secret.crwd-secrets.arn]
  }

  statement {
    sid       = "PutToLogBucket"
    actions   = ["s3:PutObject"]
    resources = (["arn:aws:s3:::${local.crwd_logs_bucket_name}/*"])
  }

}


resource "random_string" "external_id" {
  length           = 10
  override_special = "=,.@:/-"
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "snowflake_assume_role_policy" {
  version = "2012-10-17"
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [var.storage_aws_iam_user_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "sts:ExternalId"
      values = [var.storage_aws_external_id]
    }
  }
}

data "aws_iam_policy_document" "policy_document_for_snowflake" {
  statement {
    sid       = "getSecrets"
    actions   = ["secretsmanager:GetSecretValue"]
    resources = [resource.aws_secretsmanager_secret.crwd-secrets.arn]
  }

  statement {
    sid       = "ReadLogBucket"
    actions   = ["s3:GetObject","s3:GetObjectVersion"]
    resources = (["arn:aws:s3:::${local.crwd_logs_bucket_name}/*"])
    effect    = "Allow"
  }

  statement {
    sid       = "ListBucket"
    actions   = ["s3:ListBucket","s3:GetBucketLocation"]
    resources = (["arn:aws:s3:::${local.crwd_logs_bucket_name}"])
    effect    = "Allow"
  }
}

resource "aws_iam_role" "snowflake_iam_role" {
  name               = "snowflake-role-for-crwd-fdr-pull-${random_id.uniq.hex}"
  assume_role_policy = data.aws_iam_policy_document.snowflake_assume_role_policy.json
}


resource "aws_iam_role_policy" "iam_policy_for_snowflake_role" {
  name = "iam-snowflake-policy"
  role = aws_iam_role.snowflake_iam_role.id
  policy = data.aws_iam_policy_document.policy_document_for_snowflake.json
}



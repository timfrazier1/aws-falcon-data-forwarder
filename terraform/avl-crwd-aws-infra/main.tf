
provider "aws" {
  region = var.aws_region
}

resource "random_id" "uniq" {
  byte_length = 4
}

locals {
  crwd_logs_bucket_name        = (length(var.logs_bucket_name) > 0 ? var.logs_bucket_name : "${var.prefix}-fdr-logs-bucket-${random_id.uniq.hex}")
  lambda_code_bucket_name        = (length(var.lambda_bucket_name) > 0 ? var.lambda_bucket_name : "${var.prefix}-lambda-code-bucket-${random_id.uniq.hex}")
  lambda_iam_role_name = length(var.lambda_iam_role_name) > 0 ? var.lambda_iam_role_name : "avl-lambda-iam-${random_id.uniq.hex}"
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

resource "aws_iam_role" "lambda_iam_role" {
  name               = local.lambda_iam_role_name
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




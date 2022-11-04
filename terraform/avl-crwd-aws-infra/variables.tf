variable "aws_region" {
  type        = string
  default     = "us-west-2"
  description = "AWS Region to use for infrastructure"
}

variable "prefix" {
  type        = string
  default     = "avl-crwd"
  description = "The prefix that will be use at the beginning of every generated resource"
}

variable "logs_bucket_name" {
  type        = string
  default     = ""
  description = "Optional value to specify name for a newly created or existing S3 bucket for Crowdstrike logs.  If not specified, it will be auto-generated."
}

variable "lambda_bucket_name" {
  type        = string
  default     = ""
  description = "Optional value to specify name for a newly created or existing S3 bucket for Lambda function code.  If not specified, it will be auto-generated."
}

variable "snowpipe_sqs_queue_arn" {
  type        = string
  default     = ""
  description = "Value to specify arn for the SQS queue for the Snowpipe."
}

variable "iam_role_name" {
  type        = string
  default     = ""
  description = "Optional name for the IAM role for lambda function"
}

variable "storage_aws_external_id" {
  type		= string
  description	= "External ID to be updated once Snowflake S3 integration is established"
} 

variable "storage_aws_iam_user_arn" {
  type		= string
  description	= "IAM User ARN to be updated once Snowflake S3 integration is established"
} 

variable "secret_map" {
  type 		= map(string)
  description 	= "The AWS credentials provided by Crowdstrike for access to their S3 bucket where FDR logs are stored."
}

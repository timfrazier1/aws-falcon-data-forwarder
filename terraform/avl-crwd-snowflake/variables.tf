variable "snowflake_region" {
  type        = string
  default     = "us-east-2.aws"
  description = "Snowflake Region for connecting to Snowflake account"
}

variable "staging_schema_name" {
  type        = string
  default     = "EXTERNAL_STAGING"
  description = "Name to use for External Staging Schema"
}

variable "data_source_schema_name" {
  type        = string
  default     = "DATA_SOURCES"
  description = "Name to use for Data Source Schema"
}

variable "anvilogic_db_name" {
    type = string
    default = "ANVILOGIC"
    description = "Database name that Anvilogic is using"
}

variable "avl_role_name" {
  type        = string
  default     = "AVL_SNOWFLAKE_SPLUNK"
  description = "Name to use for Anvilogic Connection Role"
}

variable "s3_integration_name" {
  type        = string
  default     = "AVL_S3_INT"
  description = "Name of existing S3 Storage Integration"
}

variable "crwd_log_bucket_name" {
  type        = string
  description = "Name of existing S3 bucket for Crowdstrike Logs"
}

variable "task_warehouse_name" {
  type        = string
  description = "Name of existing Task Warehouse"
}
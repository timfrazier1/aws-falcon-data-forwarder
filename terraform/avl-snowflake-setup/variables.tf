
variable "db_name" {
  type        = string
  default     = "anvilogic"
  description = "Database name for Anvilogic to use"
}

variable "iam_role_name" {
  type        = string
  default     = "anvilogic"
  description = "Name for the IAM role for Snowflake to use for S3 Integration"
}

variable "tags" {
  type        = map(string)
  description = "A map/dictionary of Tags to be assigned to created resources"
  default     = {}
}

variable "staging_schema_name" {
  type        = string
  default     = "external_staging"
  description = "Name to use for External Staging Schema"
}

variable "data_source_schema_name" {
  type        = string
  default     = "data_sources"
  description = "Name to use for Data Source Schema"
}

variable "task_warehouse_name" {
  type        = string
  default     = "anvilogic_tasks"
  description = "Name to use for Task Warehouse"
}

variable "task_warehouse_size" {
  type        = string
  default     = "xsmall"
  description = "Size to use for Task Warehouse - e.g. xsmall, small, etc"
}

variable "detect_warehouse_name" {
  type        = string
  default     = "anvilogic_detect"
  description = "Name to use for Detect Warehouse"
}

variable "detect_warehouse_size" {
  type        = string
  default     = "xsmall"
  description = "Size to use for Detect Warehouse - e.g. xsmall, small, etc"
}

variable "avl_role_name" {
  type        = string
  default     = "avl_snowflake_splunk"
  description = "Name to use for Anvilogic Connection Role"
}

variable "avl_user_name" {
  type        = string
  default     = "avl_svcsplunk"
  description = "Name to use for Anvilogic Connection User"
}

variable "storage_integration_name" {
  type        = string
  default     = "s3_int"
  description = "Name to use for S3 Storage Integration"
}

variable "use_existing_log_bucket" {
  type        = bool
  default     = false
  description = "Set this to `true` to use an existing bucket for storage integration. Default behavior creates a new bucket for the storage integration to use"
}

variable "data_bucket_arns" {
  type        = list(string)
  default     = []
  description = "ARNs of S3 Buckets allowed for storage integration access." 
}

variable "s3_prefix" {
  type        = string
  default     = ""
  description = "Prefix to be appended to the bucket name for allowed access.  Start with '/'. "
}

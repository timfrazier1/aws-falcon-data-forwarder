output "snowflake_svc_public_key" {
    value = tls_private_key.svc_key.public_key_pem
}
output "snowflake_svc_private_key" {
    value = tls_private_key.svc_key.private_key_pem
    sensitive = true
}

output "snowflake_storage_integration_external_id" {
    value = snowflake_storage_integration.s3_integration.storage_aws_external_id
}

output "snowflake_storage_integration_iam_user" {
    value = snowflake_storage_integration.s3_integration.storage_aws_iam_user_arn
}

output "snowflake_anvilogic_db_name" {
    value = snowflake_database.anvilogic_db.name
}

output "snowflake_anvilogic_staging_schema_name" {
    value = snowflake_schema.staging_schema.name
}

output "snowflake_anvilogic_data_source_schema_name" {
    value = snowflake_schema.data_source_schema.name
}

output "snowflake_anvilogic_role_name" {
    value = snowflake_role.avl_role.name
}

output "s3_storage_integration_name" {
    value = snowflake_storage_integration.s3_integration.name
}

output "task_warehouse_name" {
    value = snowflake_warehouse.task_warehouse.name
}
/* output "role_name" {
  value       = aws_iam_role.lambda_iam_role.name 
  description = "IAM Role name"
}

output "snowflake_role_arn" {
  value       = aws_iam_role.snowflake_iam_role.arn 
  description = "Snowflake IAM Role ARN"
}
*/

output "RoleArn" {
  value       = aws_iam_role.lambda_iam_role.arn 
  description = "Lambda IAM Role ARN"
}

output "S3Bucket" {
  value       = aws_s3_bucket.crwd-logs.bucket
  description = "CRWD Log bucket Name"
}

output "S3BucketArn" {
  value       = aws_s3_bucket.crwd-logs.arn
  description = "CRWD Log bucket ARN"
}

output "CodeS3Bucket" {
  value       = aws_s3_bucket.lambda-code.bucket
  description = "Lambda Code bucket Name"
}

output "SecretArn" {
  value = aws_secretsmanager_secret.crwd-secrets.arn
  description = "Crowdstrike secrets ARN"
}

# After running terraform apply, you can run the following command to get the output values in the proper format for your configuration JSON file
# terraform output -json | jq 'keys[] as $k | "\($k):\(.[$k] | .value)"' | sed 's/:/": "/' | sed '$!s/$/,/'

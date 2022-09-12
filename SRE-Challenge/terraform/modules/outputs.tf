
# Bucket
output "bucket_name" {
  description = "Bucket name"
  value       = try(aws_s3_bucket.this[0].id, "")
}

## RDS
output "rds_endpoint_url" {
  description = "RDS Endpoint URL"
  value       = try(aws_db_instance.this[0].endpoint, "")
}
output "rds_root_username" {
  description = "DB Root username"
  value       = try(aws_db_instance.this[0].username, "")
}
output "rds_root_password" {
  description = "DB Root password"
  value       = try(aws_db_instance.this[0].password, "")
  sensitive = true
}
# iam role
output "iam_role_arn" {
  description = "IAM Role ARN"
  value       = try(aws_iam_role.this[0].arn, "")
}


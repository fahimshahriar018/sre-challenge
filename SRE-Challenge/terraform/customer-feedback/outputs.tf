# Bucket
output "customer_feedback_bucket_name" {
  description = "Bucket name"
  value       = try(module.customer-feedback.bucket_name, "")
}

## RDS
output "customer_feedback_rds_endpoint_url" {
  description = "RDS ENDPOINT URL"
  value       = try(module.customer-feedback.rds_endpoint_url, "")
}
# iam role
output "customer_feedback_iam_role_arn" {
  description = "iam Role arn"
  value       = try(module.customer-feedback.iam_role_arn, "")
}

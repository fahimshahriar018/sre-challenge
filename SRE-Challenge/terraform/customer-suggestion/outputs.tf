# Bucket
output "customer_suggestion_bucket_name" {
  description = "The name of the monitoring role"
  value       = try(module.customer-suggestion.bucket_name, "")
}

## RDS
output "customer_suggestion_rds_endpoint_url" {
  description = "The name of the monitoring role"
  value       = try(module.customer-suggestion.rds_endpoint_url, "")
}
# iam role
output "customer_suggestion_iam_role_arn" {
  description = "The name of the monitoring role"
  value       = try(module.customer-suggestion.iam_role_arn, "")
}

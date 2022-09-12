
resource "aws_ssm_parameter" "this" {
  # for_each = {
  #   s3-bucket = aws_s3_bucket.this[0].arn
  #   rds-endpoint-url = aws_db_instance.this[0].endpoint
  #   rds-root-username = aws_db_instance.this[0].username
  #   rds-root-password = aws_db_instance.this[0].password
  #   iam-role = aws_iam_role.this[0].arn
  # }
  for_each = var.ssm_parameters
  name        = "/services/${var.service_name}/${each.key}"
  type        = "String"
  value       = each.value
  tags = var.tags
}
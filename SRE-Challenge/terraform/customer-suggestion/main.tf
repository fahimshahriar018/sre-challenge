module "customer-suggestion" {
  source = "../modules"
  service_name = "customer-suggestion"
  db_engine = "mysql"
  db_engine_version = "5.7"
  rds_instance_class = "db.t3.micro"
  rds_allocated_storage = "20"
  rds_storage_type = "standard"
  rds_skip_final_snapshot = true
  db_name = "test"
  db_username = "sre_admin"
  db_password = "Password0987654321"
  rds_port = "3306"
  vpc_security_group_ids = ["sg-0cf629e6084608e5b"]
  rds_publicly_accessible = "false"
  rds_enabled_cloudwatch_logs_exports = ["error"]
  rds_deletion_protection = "false"
  iam_role_aws_service = "ec2"
  tags = {
    created_by = "terraform"
    service_name = "customer-suggestion"

  }

  ssm_parameters = {
    s3-bucket = module.customer-suggestion.bucket_name
    rds-endpoint-url = module.customer-suggestion.rds_endpoint_url
    rds-root-username = module.customer-suggestion.rds_root_username
    rds-root-password = module.customer-suggestion.rds_root_password
    iam-role = module.customer-suggestion.iam_role_arn
  }

}

locals {
  #monitoring_role_arn = var.create_monitoring_role ? aws_iam_role.enhanced_monitoring[0].arn : var.monitoring_role_arn

  rds_final_snapshot_identifier = var.rds_skip_final_snapshot ? null : var.service_name

  rds_identifier        = var.rds_use_identifier_prefix ? null : var.service_name
  rds_identifier_prefix = var.rds_use_identifier_prefix ? "${var.service_name}-" : null

  rds_monitoring_role_name        = var.rds_monitoring_role_use_name_prefix ? null : var.rds_monitoring_role_name
  rds_monitoring_role_name_prefix = var.rds_monitoring_role_use_name_prefix ? "${var.rds_monitoring_role_name}-" : null

  # Replicas will use source metadata
  db_username       = var.rds_replicate_source_db != null ? null : var.db_username
  db_password       = var.rds_replicate_source_db != null ? null : var.db_password
  db_engine         = var.rds_replicate_source_db != null ? null : var.db_engine
  db_engine_version = var.rds_replicate_source_db != null ? null : var.db_engine_version
}

resource "aws_db_instance" "this" {
  count = var.create_rds ? 1 : 0

  identifier        = local.rds_identifier
  identifier_prefix = local.rds_identifier_prefix

  engine            = local.db_engine
  engine_version    = local.db_engine_version
  instance_class    = var.rds_instance_class
  allocated_storage = var.rds_allocated_storage
  storage_type      = var.rds_storage_type
  storage_encrypted = var.rds_storage_encrypted
  kms_key_id        = var.kms_key_id
  license_model     = var.rds_license_model

  db_name                             = var.db_name
  username                            = local.db_username
  password                            = local.db_password
  port                                = var.rds_port
  domain                              = var.rds_domain
  domain_iam_role_name                = var.rds_domain_iam_role_name
  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  vpc_security_group_ids = var.vpc_security_group_ids
  db_subnet_group_name   = var.db_subnet_group_name
  parameter_group_name   = var.rds_parameter_group_name
  option_group_name      = var.rds_option_group_name

  availability_zone   = var.rds_availability_zone
  multi_az            = var.rds_multi_az
  iops                = var.rds_iops
  publicly_accessible = var.rds_publicly_accessible
  ca_cert_identifier  = var.rds_ca_cert_identifier

  allow_major_version_upgrade = var.rds_allow_major_version_upgrade
  auto_minor_version_upgrade  = var.rds_auto_minor_version_upgrade
  apply_immediately           = var.rds_apply_immediately
  maintenance_window          = var.rds_maintenance_window

  snapshot_identifier       = var.rds_snapshot_identifier
  copy_tags_to_snapshot     = var.rds_copy_tags_to_snapshot
  skip_final_snapshot       = var.rds_skip_final_snapshot
  final_snapshot_identifier = local.rds_final_snapshot_identifier

  performance_insights_enabled          = var.rds_performance_insights_enabled
  performance_insights_retention_period = var.rds_performance_insights_enabled ? var.rds_performance_insights_retention_period : null
  performance_insights_kms_key_id       = var.rds_performance_insights_enabled ? var.rds_performance_insights_kms_key_id : null

  replicate_source_db     = var.rds_replicate_source_db
  replica_mode            = var.rds_replica_mode
  backup_retention_period = var.rds_backup_retention_period
  backup_window           = var.rds_backup_window
  max_allocated_storage   = var.rds_max_allocated_storage
  monitoring_interval     = var.rds_monitoring_interval
  #monitoring_role_arn     = var.rds_monitoring_interval > 0 ? local.monitoring_role_arn : null

  character_set_name              = var.rds_character_set_name
  timezone                        = var.rds_timezone
  enabled_cloudwatch_logs_exports = var.rds_enabled_cloudwatch_logs_exports

  deletion_protection      = var.rds_deletion_protection
  delete_automated_backups = var.rds_delete_automated_backups

  dynamic "restore_to_point_in_time" {
    for_each = var.rds_restore_to_point_in_time != null ? [var.rds_restore_to_point_in_time] : []

    content {
      restore_time                             = lookup(restore_to_point_in_time.value, "restore_time", null)
      source_db_instance_automated_backups_arn = lookup(restore_to_point_in_time.value, "source_db_instance_automated_backups_arn", null)
      source_db_instance_identifier            = lookup(restore_to_point_in_time.value, "source_db_instance_identifier", null)
      source_dbi_resource_id                   = lookup(restore_to_point_in_time.value, "source_dbi_resource_id", null)
      use_latest_restorable_time               = lookup(restore_to_point_in_time.value, "use_latest_restorable_time", null)
    }
  }

  
  tags = var.tags

  depends_on = [aws_cloudwatch_log_group.this]

  timeouts {
    create = lookup(var.rds_timeouts, "create", null)
    delete = lookup(var.rds_timeouts, "delete", null)
    update = lookup(var.rds_timeouts, "update", null)
  }
}

################################################################################
# CloudWatch Log Group
################################################################################

resource "aws_cloudwatch_log_group" "this" {
  for_each = toset([for log in var.rds_enabled_cloudwatch_logs_exports : log if var.create_rds && var.create_cloudwatch_log_group])

  name              = "/aws/rds/instance/${var.service_name}/${each.value}"
  retention_in_days = var.cloudwatch_log_group_retention_in_days
  kms_key_id        = var.cloudwatch_log_group_kms_key_id

  tags = var.tags
}


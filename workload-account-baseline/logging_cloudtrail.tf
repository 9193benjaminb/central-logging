resource "aws_cloudtrail" "security_trail" {
  name = "security_trail_do_not_delete"
  s3_bucket_name = "${var.cloudtrail_bucket_name}"
  include_global_service_events = true
  is_multi_region_trail = true
  enable_log_file_validation = true
  kms_key_id = "arn:aws:kms:${var.region}:${var.logging_account}:alias/${var.cloudtrail_key_name}"
}

output "cloudtrail_name" {
  value = "${aws_cloudtrail.security_trail.name}"
}

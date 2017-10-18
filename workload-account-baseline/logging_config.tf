resource "aws_config_configuration_recorder" "security_config" {
  role_arn = "${aws_iam_role.config_role.arn}"

  recording_group {
    all_supported = "True"
    include_global_resource_types = "True"
  }
}

resource "aws_config_delivery_channel" "config_delivery_channel" {
  s3_bucket_name = "${var.config_bucket_name}"
  sns_topic_arn = "${aws_sns_topic.config_sns_topic.arn}"

  snapshot_delivery_properties {
    delivery_frequency = "One_Hour"
  }

  depends_on = ["aws_config_configuration_recorder.security_config"]
}

output "configuration_recorder" {
  value = "${aws_config_configuration_recorder.security_config.name}"
}

resource "aws_config_configuration_recorder_status" "security_config_status" {
  name       = "${aws_config_configuration_recorder.security_config.name}"
  is_enabled = true
  depends_on = ["aws_config_delivery_channel.config_delivery_channel"]
}

resource "aws_iam_role" "config_role" {
  name = "config_role"

  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "config.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy_attachment" "config_role_policy" {
  role       = "${aws_iam_role.config_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSConfigRole"
}

resource "aws_iam_role_policy" "config_inline_policies" {
  name = "PublishToSNS"
  role = "${aws_iam_role.config_role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "sns:Publish"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}

output "config_bucket" {
  value = "${var.config_bucket_name}"
}

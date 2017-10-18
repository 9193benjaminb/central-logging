resource "aws_kms_key" "cloudtrail_cmk" {
  description = "cloudtrail_key"
  deletion_window_in_days = 30
  enable_key_rotation = "True"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "Key policy created by CloudTrail",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::${var.logging_account}:root"
        ]
      },
      "Action": "kms:*",
      "Resource": "*"
    },
    {
      "Sid": "Allow CloudTrail to encrypt logs",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "kms:GenerateDataKey*",
      "Resource": "*",
      "Condition": {
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.source_account}:trail/*"
        }
      }
    },
    {
      "Sid": "Allow CloudTrail to describe key",
      "Effect": "Allow",
      "Principal": {
        "Service": "cloudtrail.amazonaws.com"
      },
      "Action": "kms:DescribeKey",
      "Resource": "*"
    },
    {
      "Sid": "Allow principals in the account to decrypt log files",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Decrypt",
        "kms:ReEncryptFrom"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${var.source_account}"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.source_account}:trail/*"
        }
      }
    },
    {
      "Sid": "Enable cross account log decryption",
      "Effect": "Allow",
      "Principal": {
        "AWS": "*"
      },
      "Action": [
        "kms:Decrypt",
        "kms:ReEncryptFrom"
      ],
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "kms:CallerAccount": "${var.source_account}"
        },
        "StringLike": {
          "kms:EncryptionContext:aws:cloudtrail:arn": "arn:aws:cloudtrail:*:${var.source_account}:trail/*"
        }
      }
    }
  ]
}
EOF
}

resource "aws_kms_alias" "cloudtrail_cmk_alias" {
  name = "alias/${var.cloudtrail_key_name}"
  target_key_id = "${aws_kms_key.cloudtrail_cmk.key_id}"
}

output "cmk" {
  value = "${aws_kms_key.cloudtrail_cmk.arn}"
}

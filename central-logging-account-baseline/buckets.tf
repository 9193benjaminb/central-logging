# This bucket receives cloudtrail and config logs
resource "aws_s3_bucket" "aws_bucket" {
  bucket = "${var.aws_bucket_name}"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "${var.aws_bucket_name}"
    prefix = "${var.aws_bucket_name}/"
    enabled = true

    transition {
      days = 90
      storage_class = "STANDARD_IA"
    }

    transition {
      days = 455
      storage_class = "GLACIER"
    }

    expiration {
      days = 2555
    }
  }

  # Ensure bucket policy is appended to in the resource part for PutObject to permit writing from your source accounts
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyDeleteAll",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:Delete*",
      "Resource": [
        "arn:aws:s3:::${var.aws_bucket_name}",
        "arn:aws:s3:::${var.aws_bucket_name}/*"
      ]
    },
    {
      "Sid": "AllowACLCheck",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com",
          "config.eu-west-1.amazonaws.com"
        ]
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.aws_bucket_name}"
    },
    {
      "Sid": "AllowServicePrincipalWrite",
      "Effect": "Allow",
      "Principal": {
        "Service": [
          "cloudtrail.amazonaws.com",
          "config.eu-west-1.amazonaws.com"
        ]
      },
      "Action": "s3:PutObject",
      "Resource": [
        "arn:aws:s3:::${var.aws_bucket_name}/AWSLogs/${var.source_account}/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF
}

output "aws_bucket" {
  value = "${aws_s3_bucket.aws_bucket.bucket}"
}

# App bucket
resource "aws_s3_bucket" "workload_bucket" {
  bucket = "${var.workload_bucket_name}"

  force_destroy = true

  versioning {
    enabled = true
  }

  lifecycle_rule {
    id = "${var.workload_bucket_name}"
    prefix = "${var.workload_bucket_name}/"
    enabled = true

    transition {
      days = 90
      storage_class = "STANDARD_IA"
    }

    expiration {
      days = 455
    }
  }

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "DenyDelete",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:Delete*",
      "Resource": [
        "arn:aws:s3:::${var.workload_bucket_name}",
        "arn:aws:s3:::${var.workload_bucket_name}/*"
      ]
    },
    {
      "Sid": "WorkloadAclCheck20131101",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.source_account}"
      },
      "Action": "s3:GetBucketAcl",
      "Resource": "arn:aws:s3:::${var.workload_bucket_name}"
    },
    {
      "Sid": "WorkloadWrite20131101",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${var.source_account}"
      },
      "Action": "s3:PutObject",
      "Resource": [
        "arn:aws:s3:::${var.workload_bucket_name}/${var.source_account}/*"
      ],
      "Condition": {
        "StringEquals": {
          "s3:x-amz-acl": "bucket-owner-full-control"
        }
      }
    }
  ]
}
EOF
}

output "workload_bucket" {
  value = "${aws_s3_bucket.workload_bucket.bucket}"
}

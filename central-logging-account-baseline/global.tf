provider "aws" {
  region  = "${var.region}"
  profile = "${var.logging_account_profile}"
}

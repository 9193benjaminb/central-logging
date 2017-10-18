resource "aws_sns_topic" "config_sns_topic" {
  name = "config_sns_topic"
}

output "config_sns_topic" {
  value = "${aws_sns_topic.config_sns_topic.arn}"
}

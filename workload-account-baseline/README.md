# Workload Account - Baseline Configuration
Baseline configuration consists of creating and configuring a bucket for config and cloudtrail and a bucket for applications.

- initial setup of CloudTrail and AWS Config  
- setup of SNS topic for config reports
- setup role for config

Please update the [variables](variables.tf) as appropriate:

- "region" ~ region to be used e.g. eu-west-1
- "source_account" ~ account id / arn for the account that will be writing the logs
- "logging_account" ~ account id / arn for the central logging account 
- "config_bucket_name" ~ name of the bucket to be used for storing AWS logs (CloudTrail / Config)
- "cloudtrail_bucket_name" ~ name of the bucket to be used for storing application / workload logs (SysLog etc)
- "cloudtrail_key_name" ~ name of the key to be used for CloudTrail

## Enable CloudTrail Logging
[code](logging_cloudtrail.tf)

## Enable Config logging
[code](logging_config.tf)

## Enable SNS for logging
[code](logging_sns.tf)
# Central Logging Account - Baseline Configuration
Baseline configuration consists of creating and configuring a bucket for config and cloudtrail and a bucket for applications.

1. Create/update CMK to encrypt CloudTrail data
2. Create/update AWS and Application buckets

Please update the [variables](variables.tf) as appropriate:

- "region" ~ region to be used e.g. eu-west-1
- "logging_account" ~ account id / arn for the central logging account 
- "logging_account_profile" ~ profile of the account being used to execute the code
- "aws_bucket_name" ~ name of the bucket to be used for storing AWS logs (CloudTrail / Config)
- "workload_bucket_name" ~ name of the bucket to be used for storing application / workload logs (SysLog etc)
- "source_account" ~ account id / arn for the account that will be writing the logs
- "cloudtrail_key_name" ~ name of the key to be used for CloudTrail

## Create/update CMK to encrypt CloudTrail data
[code](cmk.tf)

## Create/update log and security data buckets
[code](buckets.tf)

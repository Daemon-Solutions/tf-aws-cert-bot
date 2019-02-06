# tf-aws-cert-bot

A simple scheduled Lambda function to check expiry on SSL certificates and report to Slack when they get close to expiring

## Example

This example will check www.google.com and send notifications to slack when the expiry is 14 days or less, checked daily at 9am.

```
module "ssl_check" {
  source = "../"

  name       = "test_ssl_checker"
  url        = "www.google.com"
  warn_days  = 14
  alert_days = 7
  slack_url  = "https://hooks.slack.com/services/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"
  schedule = "cron(0 9 * * ? *)"
}
```

## Parameters

| Parameter  | Description                  | Default Value     |
|------------|------------------------------|-------------------|
| name       | Lambda function name         | ssl_checker       |
| url        | URL to check certificate age |                   |
| warn_days  | Days to send Warning message | 14                |
| alert_days | Days to send Alert message   | 7                 |
| slack_url  | Slack Webhook URL            |                   |
| schedule   | Cloudwatch Cron Schedule     | cron(0 9 * * ? *) |

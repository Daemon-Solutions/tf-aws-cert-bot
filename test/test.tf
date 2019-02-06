module "ssl_check" {
  source = "../"

  name       = "test_ssl_checker"
  url        = "www.google.com"
  warn_days  = 14
  alert_days = 7
  slack_url  = "https://hooks.slack.com/services/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"
  schedule = "cron(0 9 * * ? *)"
}
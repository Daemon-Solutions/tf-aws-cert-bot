variable "name" {
  type = "string"
  description = "Name for Lambda function"
  default = "ssl_checker"
}

variable "url" {
  type = "string"
  description = "URL to check SSL expiry"
}

variable "warn_days" {
  type = "string"
  description = "No. of days before expiry to Warn via slack"
  default = "14"
}

variable "alert_days" {
  type = "string"
  description = "No. of days before expiry to Alert via slack"
  default = "7"
}

variable "slack_url" {
  type = "string"
  description = "URL for Slack Web Hook"
}

variable "schedule" {
  type = "string"
  description = "Schedule for checking SSL Expiry"
  default = "cron(0 9 * * ? *)"
}

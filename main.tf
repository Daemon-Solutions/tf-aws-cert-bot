module "lambda" {
  source = "github.com/claranet/terraform-aws-lambda"

  function_name = "${var.name}"
  description   = "SSL Expiry Check for ${var.url}"
  handler       = "lambda.handler"
  runtime       = "python3.6"
  timeout       = 300

  // Specify a file or directory for the source code.
  source_path = "${path.module}/lambda.py"

  // Add environment variables.
  environment {
    variables {
      CHECK_URL = "${var.url}"
      SLACK_URL = "${var.slack_url}",
      WARN_DAYS = "${var.warn_days}",
      ALERT_DAYS = "${var.alert_days}"
    }
  }
}

resource "aws_cloudwatch_event_rule" "rule_ssl_check" {
  name                = "${var.name}"
  description         = "SSL expiry check event rule"
  schedule_expression = "${var.schedule}"
}

resource "aws_cloudwatch_event_target" "target_ssl_check" {
  target_id = "${var.name}"
  rule      = "${aws_cloudwatch_event_rule.rule_ssl_check.name}"
  arn       = "${module.lambda.function_arn}"
}

resource "aws_lambda_permission" "cw_events" {
  statement_id  = "${var.name}"
  action        = "lambda:InvokeFunction"
  function_name = "${module.lambda.function_name}"
  principal     = "events.amazonaws.com"
  source_arn    = "${aws_cloudwatch_event_rule.rule_ssl_check.arn}"
}
# CloudWatch Event Rule
resource "aws_cloudwatch_event_rule" "ec2_termination" {
  name        = "ec2-instance-termination"
  description = "Capture EC2 instance termination events"

  event_pattern = jsonencode({
    "source": ["aws.ec2"],
    "detail-type": ["EC2 Instance State-change Notification"],
    "detail": {
      "state": ["terminated"]
    }
  })
}

resource "aws_sns_topic" "billing_notifications" {
  name = "billing-notifications"
}

# Lambda Function
resource "aws_lambda_function" "billing_report" {
  function_name = "billing_report_function"
  runtime       = "python3.8"
  handler       = "lambda_function.lambda_handler"
  role          = aws_iam_role.lambda_exec.arn



  # Upload Lambda code
  filename         = "billing_report.zip"
  source_code_hash = filebase64sha256("billing_report.zip")

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.billing_notifications.arn
    }
  }
}

# CloudWatch Event Target
resource "aws_cloudwatch_event_target" "lambda_target" {
  rule      = aws_cloudwatch_event_rule.ec2_termination.name
  target_id = "SendBillingReport"
  arn       = aws_lambda_function.billing_report.arn
}

# Allow CloudWatch to Invoke Lambda
resource "aws_lambda_permission" "allow_cloudwatch" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.billing_report.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ec2_termination.arn
}

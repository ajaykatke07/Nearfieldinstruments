resource "aws_sns_topic" "billing_notifications" {
  name = "billing-notifications"
}

resource "aws_sns_topic_subscription" "email_subscriptions" {
  for_each = toset(var.subscriber_emails)

  topic_arn = aws_sns_topic.billing_notifications.arn
  protocol  = "email"
  endpoint  = each.value
}

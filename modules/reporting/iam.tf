resource "aws_iam_role" "lambda_exec" {
  name = "lambda-billing-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement: [
      {
        Action: "sts:AssumeRole",
        Effect: "Allow",
        Principal: {
          Service: "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-billing-policy"

policy = jsonencode({
  Version = "2012-10-17",
  Statement: [
    {
      Action: [
        "ec2:DescribeInstances",
        "ce:GetCostAndUsage"
      ],
      Effect: "Allow",
      Resource: "*"
    },
    {
      Action: "sns:Publish",
      Effect: "Allow",
      Resource: aws_sns_topic.billing_notifications.arn
    }
  ]
})

}

resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

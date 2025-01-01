# Create an IAM Role for Lambda Execution
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

# Define the IAM Policy for Lambda Permissions
resource "aws_iam_policy" "lambda_policy" {
  name = "lambda-billing-policy"

  policy = data.aws_iam_policy_document.lambda_policy.json
}

# Create a Policy Document
data "aws_iam_policy_document" "lambda_policy" {
  statement {
    sid     = "AllowEC2AndBillingAccess"
    actions = [
      "ec2:DescribeInstances",
      "ce:GetCostAndUsage"
    ]
    resources = ["*"] # Scope this down if specific resources are available
    effect    = "Allow"
  }

  statement {
    sid     = "AllowSNSPublish"
    actions = [
      "sns:Publish"
    ]
    resources = [aws_sns_topic.billing_notifications.arn]
    effect    = "Allow"
  }

  # Add S3 Backend Permissions
  statement {
    sid     = "AllowS3BackendAccess"
    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.terraform_backend.arn,              # S3 bucket itself
      "${aws_s3_bucket.terraform_backend.arn}/*"        # All objects in the bucket
    ]
    effect    = "Allow"
  }

  # Add DynamoDB Backend Permissions
  statement {
    sid     = "AllowDynamoDBBackendAccess"
    actions = [
      "dynamodb:GetItem",
      "dynamodb:PutItem",
      "dynamodb:DeleteItem",
      "dynamodb:Scan"
    ]
    resources = [aws_dynamodb_table.terraform_lock_table.arn]
    effect    = "Allow"
  }
}

# Attach the IAM Policy to the Lambda Role
resource "aws_iam_role_policy_attachment" "attach_lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

# Create S3 Bucket for Backend (if not already created)
resource "aws_s3_bucket" "terraform_backend" {
  bucket = "my-unique-terraform-backend-bucket" # Ensure this name is globally unique
  aws_s3_bucket_acl    = "private"

  tags = {
    Name = "TerraformBackendBucket"
  }
}

resource "aws_s3_bucket_versioning" "terraform_backend_versioning" {
  bucket = aws_s3_bucket.terraform_backend.id

  versioning_configuration {
    status = "Enabled"
  }
}


# Create DynamoDB Table for Backend Locking
resource "aws_dynamodb_table" "terraform_lock_table" {
  name         = "terraform-lock-table"
  hash_key     = "LockID"
  billing_mode = "PAY_PER_REQUEST"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "TerraformLockTable"
  }
}

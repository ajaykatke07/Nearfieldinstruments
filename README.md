# Nearfieldinstruments


# Terraform AWS Infrastructure Automation

This repository contains Terraform configurations to deploy and manage AWS infrastructure, including:
- Custom VPC with subnets.
- EC2 instance with a Lambda-triggered billing report.
- Auto Scaling Group with scheduled scaling.
- SNS notifications.
- S3 and DynamoDB for state management.

## Features

- **State Management**: Uses S3 for state storage and DynamoDB for locking.
- **Custom VPC**: Creates a VPC with dynamically generated subnets.
- **EC2 Instances**: Launches an Ubuntu instance with Free Tier eligibility.
- **Auto Scaling Group**: Configurable with scheduled scaling actions.
- **SNS Notifications**: Sends notifications for instance lifecycle events.
- **Lambda Billing Reports**: Generates mock billing reports on instance termination.
- **API Gateway Integration**: Exposes a REST API for triggering the Lambda function.

## File Structure

```plaintext
.
├── main.tf               # Main Terraform configuration
├── backend.tf            # Backend configuration for state management
├── variables.tf          # Input variables
├── billing_report.zip    # Packaged Lambda function
├── modules/              # Directory for reusable Terraform modules
│   ├── vpc/              # VPC module
│   ├── ami/              # AMI module
│   ├── autoscaling/      # Auto Scaling Group module
│   ├── notifications/    # SNS notifications module
│   ├── reporting/        # Lambda and API Gateway module
```

## Prerequisites

- **AWS CLI**: Configure with proper credentials.
- **Terraform**: Version latest
- **IAM Permissions**: User/role should have access to:
  - `AmazonEC2FullAccess`
  - `AmazonS3FullAccess`
  - `DynamoDBFullAccess`
  - `AWSLambda_FullAccess`
  - `AmazonAPIGatewayAdministrator`
  - `CloudWatchFullAccess`

## Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/ajaykatke07/Nearfieldinstruments.git
cd Nearfieldinstruments
```

### 2. Initialize Terraform

```bash
terraform init
```

### 3. Review the Plan

```bash
terraform plan
```

### 4. Apply the Configuration

```bash
terraform apply
```

## Backend Configuration

### S3 Bucket for State
Create an S3 bucket to store the Terraform state file:
```bash
aws s3api create-bucket --bucket your-s3-bucket-name --region us-east-1
aws s3api put-bucket-versioning --bucket your-s3-bucket-name --versioning-configuration Status=Enabled
```

### DynamoDB for Locking
Create a DynamoDB table for state locking:
```bash
aws dynamodb create-table     --table-name terraform-lock-table     --attribute-definitions AttributeName=LockID,AttributeType=S     --key-schema AttributeName=LockID,KeyType=HASH     --provisioned-throughput ReadCapacityUnits=5,WriteCapacityUnits=5
```

## Lambda Function

### Functionality
- Generates a billing report for terminated EC2 instances.
- Sends the report via SNS to subscribers.

### Example Code (`lambda_function.py`)
The function is packaged in `billing_report.zip`.

### Deploying Lambda
- Ensure `billing_report.zip` contains the `lambda_function.py` file:
  ```bash
  zip billing_report.zip lambda_function.py
  ```

## Cleanup

To delete all resources:
```bash
terraform destroy
```

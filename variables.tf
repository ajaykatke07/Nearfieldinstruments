variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_cidr_block" {
  default = "10.0.0.0/16"
}

variable "public_subnets" {
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "ami_id" {
  # Replace with an official Ubuntu AMI
  default = "ami-0abcdef1234567890"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  description = "SSH Key Pair for EC2 instances"
  default     = "my-key"
}

variable "scale_up_schedule" {
  default = "06:00"
}

variable "scale_down_schedule" {
  default = "18:00"
}

variable "alert_email" {
  description = "Email address for SNS alerts"
  default     = "your-email@example.com"
}

variable "cpu_threshold_alarm" {
  description = "Threshold for CPU Utilization"
  default     = 1
}

variable "common_tags" {
  default = {
    Environment = "Production"
    Project     = "TerraformDemo"
  }
}

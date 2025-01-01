terraform {
  backend "s3" {
    bucket         = "my-unique-terraform-backend-bucket"
    key            = "terraform/state.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
    encrypt        = true
  }
}
terraform {
  backend "s3" {
    bucket         = "terrform_state"       
    key            = "terraform/state.tfstate"  
    region         = "us-east-1"               
    dynamodb_table = "terraform-lock-table"     
    encrypt        = true                      
  }
}
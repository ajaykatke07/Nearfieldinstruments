provider "aws" {
  region = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
  vpc_name = "MyAppVPC"
  cidr_block = "10.0.0.0/16"
  subnet_count = 2
}

module "ami" {
  source = "./modules/ami"
  subnet_id = module.vpc.subnet_ids[0]
}

module "autoscaling" {
  source     = "./modules/autoscaling"
  ami_id     = module.ami.instance_ami_id 
  subnet_ids = module.vpc.subnet_ids       
}

module "notifications" {
  source           = "./modules/notifications"
  subscriber_emails = ["ajay.katke@gmail.com", "ajay.katke@outlook.com"]
}

module "reporting" {
  source = "./modules/reporting"
  subscriber_emails = ["ajay.katke@gmail.com", "ajay.katke@outlook.com"]
}


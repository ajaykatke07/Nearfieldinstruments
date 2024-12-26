variable "ami_id" {
  type        = string
  description = "The AMI ID to use for the instances"
}

variable "subnet_ids" {
  type        = list(string)
  description = "A list of subnet IDs to place the instances in"
}

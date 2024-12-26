variable "vpc_name" {
  description = "Name of the VPC"
  type        = string
}

variable "cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_support" {
  description = "Enable DNS support in the VPC"
  type        = bool
  default     = true
}

variable "dns_hostnames" {
  description = "Enable DNS hostnames in the VPC"
  type        = bool
  default     = true
}

variable "subnet_cidr" {
  description = "CIDR block for the subnets"
  type        = string
  default     = "10.0.1.0/24"
}

variable "subnet_count" {
  description = "Number of subnets to create"
  type        = number
  default     = 2
}

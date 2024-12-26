resource "aws_vpc" "basic_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "example_subnet" {
  count      = var.subnet_count  # Create multiple subnets if needed
  vpc_id     = aws_vpc.basic_vpc.id
  cidr_block = cidrsubnet(var.cidr_block, 8, count.index)  # Dynamically allocate CIDR blocks

  tags = {
    Name = "${var.vpc_name}-subnet-${count.index + 1}"
  }
}

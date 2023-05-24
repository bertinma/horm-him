module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "4.0.1"

  name = "horm_him_vpc"
  cidr = var.vpc_cidr_block

  azs             = var.aws_availability_zone_names
  private_subnets = [for i in range(1, 5, 2) : cidrsubnet(var.vpc_cidr_block, 8, i)]
  public_subnets  = [for i in range(2, 5, 2) : cidrsubnet(var.vpc_cidr_block, 8, i)]

  enable_nat_gateway = true

  tags = var.default_tags
}
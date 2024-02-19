provider "aws" {
    region = "ap-south-1"
}

module "my_vpc" {
  source = "./modules"  

  vpc_cidr            = var.vpc_cidr
  availability_zones  = var.availability_zones
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
}
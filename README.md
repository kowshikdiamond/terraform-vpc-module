# Terraform Module for AWS VPC creation

Terraform module to create a VPC with three public and three private subnets in each available zone, attaching the default route table to the three public subnets, associating it with an internet gateway, and creating three route tables to attach to each private subnet.

Usage: Create a terraform.tfvars file to pass the required variables
```
variable "vpc_cidr" {}
variable "public_subnet_cidrs" {
    type = list(string)
}
variable "private_subnet_cidrs" {
    type = list(string)
}
variable "availability_zones" {
    type = list(string)
}
```
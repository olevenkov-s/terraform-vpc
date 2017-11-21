terraform {
  backend "s3" {
    # Be sure to change this bucket name and region to match an S3 Bucket you have already created!
    bucket = "terraform-slalom"
    region = "us-east-2"
    key    = "VPC/terraform.tfstate"
    encrypt = true
    #terraform locking
    #dynamodb_table = "terrafform-lock"
  }
}

provider "aws" {
region = "us-east-2"    
}


module "vpc" {
  source = "./modules/"

  name = "terraform-vpc"

  cidr = "10.10.0.0/16"

  azs                 = ["us-east-2a", "us-east-2b", "us-east-2c"]
  private_subnets     = ["10.10.1.0/24", "10.10.2.0/24", "10.10.3.0/24"]
  public_subnets      = ["10.10.11.0/24", "10.10.12.0/24", "10.10.13.0/24"]
  database_subnets    = ["10.10.21.0/24", "10.10.22.0/24", "10.10.23.0/24"]
  elasticache_subnets = ["10.10.31.0/24", "10.10.32.0/24", "10.10.33.0/24"]

  create_database_subnet_group = true

  enable_nat_gateway = true

  enable_s3_endpoint       = true
  enable_dynamodb_endpoint = true

  enable_dhcp_options              = true
  dhcp_options_domain_name         = "service.consul"
  dhcp_options_domain_name_servers = ["127.0.0.1", "10.10.0.2"]

  tags = {
    Owner       = "Oleg Levenkov"
    Environment = "Test-Terraform"
  }
}
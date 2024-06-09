terraform {
  required_version = "1.8.4"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.49.0"
    }
  }
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"

  name = "crud-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["sa-east-1a", "sa-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]
  private_subnets = ["10.0.3.0/24", "10.0.4.0/24"]

  enable_nat_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

module "security_group" {
  source = "./modules/security_group"

  vpc_id = module.vpc.vpc_id

  depends_on = [module.vpc]
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table
  hash_key   = var.dynamodb_hash_key
}

module "lambda" {
  source               = "./modules/lambda"
  vpc_id               = module.vpc.vpc_id
  subnets              = module.vpc.private_subnets
  security_group_id    = module.security_group.security_group_id
  lambda_function_name = var.lambda_function_name
  handler              = var.lambda_handler
  runtime              = var.lambda_runtime
  filename             = var.lambda_filename
  dynamodb_table_arn   = module.dynamodb.table_arn
  table_name           = module.dynamodb.table_name
  depends_on           = [module.dynamodb, module.vpc, module.security_group]
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_arn
  region              = var.region
  depends_on          = [module.lambda]
}

data "aws_caller_identity" "current" {}
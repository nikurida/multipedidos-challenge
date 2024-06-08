terraform {
  required_version = "~> 1.3"

  backend "s3" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

module "dynamodb" {
  source     = "./modules/dynamodb"
  table_name = var.dynamodb_table
  hash_key   = var.dynamodb_hash_key
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = var.lambda_function_name
  handler              = var.lambda_handler
  runtime              = var.lambda_runtime
  filename             = var.lambda_filename
  dynamodb_table_arn   = module.dynamodb.table_arn
  table_name           = module.dynamodb.table_name
  depends_on           = [module.dynamodb]
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_arn
  depends_on          = [module.lambda]
}



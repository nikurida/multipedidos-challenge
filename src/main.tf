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
  table_name = "crud-table"
  hash_key   = "id"
}

module "lambda" {
  source               = "./modules/lambda"
  lambda_function_name = "crudLambdaFunction"
  handler              = "index.handler"
  runtime              = "nodejs16.x"
  filename             = "lambda.zip"
  dynamodb_table_arn   = module.dynamodb.table_arn
  table_name           = module.dynamodb.table_name
}

module "apigateway" {
  source              = "./modules/apigateway"
  lambda_function_arn = module.lambda.lambda_arn
}

variable "lambda_function_name" {
  description = "The name of the Lambda function"
}

variable "handler" {
  description = "The handler for the Lambda function"
}

variable "runtime" {
  description = "The runtime for the Lambda function"
}

variable "filename" {
  description = "The filename of the Lambda function zip"
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
}

variable "table_name" {
  description = "The name of the DynamoDB table"
}

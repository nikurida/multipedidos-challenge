variable "lambda_function_name" {
  description = "The name of the Lambda function"
  type        = string
}

variable "handler" {
  description = "The handler for the Lambda function"
  type        = string
}

variable "runtime" {
  description = "The runtime for the Lambda function"
  type        = string
}

variable "filename" {
  description = "The filename of the Lambda function code"
  type        = string
}

variable "dynamodb_table_arn" {
  description = "The ARN of the DynamoDB table"
  type        = string
}

variable "table_name" {
  description = "The name of the DynamoDB table"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "subnets" {
  description = "Subnets IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security Group ID"
  type        = string
}

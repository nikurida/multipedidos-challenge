resource "aws_iam_role" "lambda_role" {
  name               = "lambda_execution_role"
  assume_role_policy = jsonencode(local.lambda_assume_role_policy)
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_dynamodb_policy"
  description = "IAM policy for Lambda to access DynamoDB and CloudWatch Logs"
  policy      = jsonencode(local.dynamodb_policy)
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_function" "crud_lambda" {
  function_name    = var.lambda_function_name
  role             = aws_iam_role.lambda_role.arn
  handler          = var.handler
  runtime          = var.runtime
  filename         = var.filename
  source_code_hash = filebase64sha256(var.filename)

  vpc_config {
    subnet_ids         = var.subnets
    security_group_ids = [var.security_group_id]
  }

  environment {
    variables = {
      TABLE_NAME = var.table_name
    }
  }
}

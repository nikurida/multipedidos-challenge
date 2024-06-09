#!/bin/bash

# Carregar variáveis de ambiente do arquivo .env
set -o allexport
source .env
set -o allexport

# Debug: Verificar se as variáveis de ambiente estão carregadas
export AWS_REGION="sa-east-1"
export AWS_PROFILE="terraform"

# Criar arquivo terraform.tfvars.json
cat > terraform.tfvars.json <<EOL
{
  "region": "${AWS_REGION}",
  "profile": "${AWS_PROFILE}",
  "dynamodb_table": "${DYNAMODB_TABLE_NAME}",
  "dynamodb_hash_key": "${DYNAMODB_HASH_KEY}",
  "lambda_function_name": "${LAMBDA_FUNCTION_NAME}",
  "lambda_handler": "${LAMBDA_HANDLER}",
  "lambda_runtime": "${LAMBDA_RUNTIME}",
  "lambda_filename": "lambda.zip"
}
EOL

# Inicializar Terraform
terraform init

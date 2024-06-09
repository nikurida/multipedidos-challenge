#!/bin/bash

# Define o diretório da Lambda
LAMBDA_DIR="lambda"
ZIP_FILE="lambda.zip"

# Verifica se o diretório da Lambda existe
if [ ! -d "$LAMBDA_DIR" ]; then
  echo "Diretório $LAMBDA_DIR não encontrado!"
  exit 1
fi

# Entrar no diretório da Lambda
cd $LAMBDA_DIR

# Instalar as dependências
npm install

# Voltar para o diretório raiz do projeto
cd ..

# Remover o arquivo zip antigo, se existir
rm -f $ZIP_FILE

# Criar um novo arquivo zip com o conteúdo do diretório da Lambda (não incluindo a pasta lambda)
cd $LAMBDA_DIR
zip -r ../$ZIP_FILE *

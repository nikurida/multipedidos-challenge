# Multipedidos Challenge

Este projeto foi criado para resolver um desafio técnico usando Terraform para configurar a infraestrutura na AWS.

## Dependências

- [AWS CLI](https://aws.amazon.com/cli/)
- [Terraform](https://www.terraform.io/)
- [tfenv](https://github.com/tfutils/tfenv) (opcional, para gerenciar versões do Terraform)

## Configuração

1. **Instale as dependências:**

   - AWS CLI: Siga as instruções no [site oficial](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html).
   - Terraform: Siga as instruções no [site oficial](https://learn.hashicorp.com/tutorials/terraform/install-cli).
   - tfenv (opcional): Siga as instruções no [repositório oficial](https://github.com/tfutils/tfenv).

2. **Configure suas credenciais AWS:**

   Configure suas credenciais AWS usando o AWS CLI:

   ```sh
   aws configure

3. **Clone o repositório:**

   ```sh
   git clone git@github.com:nikurida/multipedidos-challenge.git
   cd multipedidos-challange

4. **Copie o arquivo de exemplo .env-example para .env e preencha as informações necessárias:**

   ```sh
   cp .env-example .env

5. **Inicialize e aplique o Terraform:**

   ```sh
   tfenv use ou tfenv install # caso utilize o tfenv
   cd src
   terraform init
   terraform apply

## Estrutura do Projeto

- `src/main.tf`: Arquivo principal do Terraform.
- `src/providers.tf`: Configuração dos provedores.
- `src/variables.tf`: Definição das variáveis.
- `src/outputs.tf`: Definição das saídas.
- `src/modules/vpc`: Módulo para configuração da VPC.
- `src/modules/dynamodb`: Módulo para configuração do DynamoDB.
- `src/modules/lambda`: Módulo para configuração do Lambda.
- `src/modules/apigateway`: Módulo para configuração do API Gateway.

## Uso

Após aplicar o Terraform, a infraestrutura será criada na AWS conforme especificado nos arquivos de configuração.

## Testando a API

1. **Obtenha o endpoint da API Gateway:**

   Após a conclusão da execução do Terraform, você pode encontrar o endpoint da API Gateway no console da AWS ou através da saída do Terraform, se configurado para mostrar o endpoint.

2. **Envie uma solicitação HTTP:**

   Use ferramentas como `curl`, Postman ou qualquer cliente HTTP de sua escolha para enviar uma solicitação para o endpoint da API.

   ```sh
   curl -X GET <API_GATEWAY_ENDPOINT>/path

   Substitua <API_GATEWAY_ENDPOINT> pelo endpoint real da API Gateway e /path pelo caminho específico configurado no API Gateway.

3. **Verifique a resposta:**

   A resposta deve ser a saída esperada da função Lambda configurada. Verifique os logs no CloudWatch para depuração, se necessário.

---

Este README.md fornece uma visão geral básica do projeto e das etapas necessárias para configurá-lo e usá-lo. Para detalhes adicionais, consulte a documentação oficial das ferramentas mencionadas.

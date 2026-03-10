# hackaton-soat-infra

Infraestrutura para o projeto SOAT Hackathon, utilizando Terraform e AWS.

## Componentes Principais

- **VPC**: Rede isolada para os recursos do projeto.
- **EKS (Kubernetes)**: Orquestração de containers com integração ao Karpenter para escalabilidade automática.
- **Karpenter**: Provisão automática de nós para o cluster EKS.
- **S3**: Armazenamento do front-end, lambda e arquivos da aplicação.
- **CloudFront**: CDN para distribuição global do front-end.
- **SES**: Envio de e-mails transacionais e de verificação, pelo Lambda.
- **SQS**: Filas para processamento assíncrono de mensagens.
- **DynamoDB**: Banco de dados NoSQL para processamento de dados.
- **Lambda**: Funções serverless para notificações via SES.
- **Cognito**: Autenticação e autorização de usuários, com login por e-mail.
- **API Gateway**: Exposição de APIs REST protegidas pelo Cognito, integradas ao backend Kubernetes/Karpenter.

## Estrutura de Pastas

- `infra/terraform/` - Código Terraform dividido por recursos (eks, vpc, s3, cloudfront, cognito, etc).
- `infra/terraform/environment/` - Variáveis específicas por ambiente (`dev`, `hom`, `prod`).

## Como usar localmente

1. Configure suas credenciais AWS (ex: via AWS CLI ou variáveis de ambiente).
2. Copie o arquivo `terraform.tfvars.example` para o ambiente desejado e ajuste os valores.
3. Inicialize o Terraform:
    ```sh
    terraform init
    ```
4. Selecione o ambiente:
    ```sh
    terraform workspace select dev # ou hom/prod
    ```
5. Aplique a infraestrutura:
    ```sh
    terraform apply -var-file=environment/dev/terraform.tfvars
    ```

## Principais Outputs

Após o apply, consulte os principais endpoints e recursos gerados:

- URL do front-end (CloudFront)
- Endpoint do cluster EKS
- URLs das filas SQS
- IDs e ARNs do Cognito (User Pool, Client)
- Endpoint do API Gateway

## Observações

- Todos os recursos seguem padrão de nomeação `hackaton-soat` para fácil identificação.
- O Cognito está configurado para login por e-mail, nickname opcional, sem MFA, e página de login gerenciada pelo Cognito.
- O API Gateway protege os endpoints usando autenticação Cognito.
- O Karpenter faz o provisionamento automático de nós para o cluster Kubernetes.

resource "aws_dynamodb_table" "hackaton-soat-processing" {
  name         = "hackaton-soat-processing-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "process_id"

  attribute {
    name = "process_id"
    type = "S"
  }
}
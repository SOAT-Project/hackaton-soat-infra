resource "aws_dynamodb_table" "hackaton_soat_processing" {
  name         = "hackaton-soat-processing"
  billing_mode = "PAY_PER_REQUEST"

  hash_key = "process_id"

  attribute {
    name = "process_id"
    type = "S"
  }

  attribute {
    name = "user_id"
    type = "S"
  }

  global_secondary_index {
    name            = "user_id-index"
    hash_key        = "user_id"
    projection_type = "ALL"
  }
}
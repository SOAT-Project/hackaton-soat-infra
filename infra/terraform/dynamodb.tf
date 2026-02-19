resource "aws_dynamodb_table" "hackaton-soat-processing" {
  name         = "hackaton-soat-processing-${var.environment}"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "process_id"

  attribute {
    name = "user_id"
    type = "S"
  }

  attribute {
    name = "process_id"
    type = "S"
  }

  attribute {
    name = "file_bucket"
    type = "S"
  }

  attribute {
    name = "file_path"
    type = "S"
  }

  attribute {
    name = "file_name"
    type = "S"
  }

  attribute {
    name = "file_size"
    type = "S"
  }

  attribute {
    name = "status"
    type = "S"
  }

  attribute {
    name = "error_message"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "S"
  }

  attribute {
    name = "processed_at"
    type = "S"
  }
}
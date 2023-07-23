terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.16"
    }
  }
}

# resource "aws_s3_bucket" "flaskapp-s3-backend-bucket" {
#   bucket        = "flaskapp-s3-backend-bucket"
#   force_destroy = true
#   tags = {
#     Name = "flaskapp_s3_backend_bucket"
#   }
# }

# resource "aws_s3_bucket_versioning" "versioning_example" {
#   bucket = aws_s3_bucket.flaskapp-s3-backend-bucket.id
#   versioning_configuration {
#     status = "Disabled"
#   }
# }

# resource "aws_dynamodb_table" "s3_lock" {
#   name     = "flaskapp_s3_lock"
#   hash_key = "LockID"

#   billing_mode   = "PROVISIONED"
#   read_capacity  = 1
#   write_capacity = 1

#   attribute {
#     name = "LockID"
#     type = "S"
#   }

#   tags = {
#     Name = "lock"
#   }
# }

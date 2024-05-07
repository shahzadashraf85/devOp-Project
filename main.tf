provider "aws" {
  region = "us-west-2"
}

resource "aws_kms_key" "mykey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "shahzadbucket" {
  bucket = "shahzadbucket"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "shahzadbucketencryption" {
  bucket = aws_s3_bucket.shahzadbucket.id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.mykey.arn
      sse_algorithm     = "aws:kms"
    }
  }
}
resource "aws_s3_bucket_acl" "shahzadbucket_acl" {
  bucket = aws_s3_bucket.shahzadbucket.id
  acl    = "private"
}

resource "aws_s3_bucket_versioning" "shahzadbucket_version" {
  bucket = aws_s3_bucket.shahzadbucket.id
  versioning_configuration {
    status = "Enabled"
  }
}
data "aws_secretsmanager_random_password" "test" {
  password_length = 50
  exclude_numbers = true
}
resource "random_password" "my_secret_password" {
  length           = 20
  special          = true
  override_special = "!@#$%^&*()_+"
}

resource "aws_secretsmanager_secret" "my_secret" {
  name = "MySecret"
}

resource "aws_secretsmanager_secret_version" "my_secret_version" {
  secret_id = aws_secretsmanager_secret.my_secret.id
  secret_string = jsonencode({
    username = "Shahzad",
    password = random_password.my_secret_password.result
  })
}
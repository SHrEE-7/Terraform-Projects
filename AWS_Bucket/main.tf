provider "aws" {
  region = "ap-south-1"
}
resource "aws_s3_bucket" "shrees_bucket" {
  bucket = "shrees-s3-bucket-first"
  # versioning {
  #   enabled = true
  # }
  resource "aws_s3_bucket_versioning" "versioning_example" {
    bucket = aws_s3_bucket.shrees_bucket.id
    versioning_configuration {
      status = "Enabled"
    }
  }
}

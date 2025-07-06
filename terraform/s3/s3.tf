resource "aws_s3_bucket" "bucket_a" {
  bucket = var.bucket_a_name
}

resource "aws_s3_bucket" "bucket_b" {
  bucket = var.bucket_b_name
}


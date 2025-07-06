provider "aws" {
  region = var.region
}

module "s3" {
  source = "./s3"

  bucket_a_name = "bucket-akash-a-genomics"
  bucket_b_name = "bucket-akash-b-genomics"
}

module "iam" {
  source = "./iam"

  user_a_name  = "userakash"
  user_b_name  = "userbhola"
  bucket_a_arn = module.s3.bucket_a_arn
  bucket_b_arn = module.s3.bucket_b_arn
}

module "lambda" {
  source = "./lambda"

  bucket_a_name = module.s3.bucket_a_name
  bucket_b_name = module.s3.bucket_b_name
  bucket_a_arn  = module.s3.bucket_a_arn
  bucket_a_id   = module.s3.bucket_a_id
}

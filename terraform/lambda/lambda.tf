data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "../lambda"
  output_path = "../lambda.zip"
}

resource "aws_iam_role" "lambda_exec" {
  name = "lambda_exec_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_lambda_function" "exif_cleaner" {
  filename         = data.archive_file.lambda_zip.output_path
  function_name    = "ExifCleaner"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "exif_cleaner.lambda_handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "python3.9"

  environment {
    variables = {
      DEST_BUCKET = var.bucket_b_name
    }
  }
}

resource "aws_lambda_permission" "allow_s3" {
  statement_id  = "AllowExecutionFromS3"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.exif_cleaner.function_name
  principal     = "s3.amazonaws.com"
  source_arn    = var.bucket_a_arn
}

resource "aws_s3_bucket_notification" "trigger_lambda" {
  bucket = var.bucket_a_id

  lambda_function {
    lambda_function_arn = aws_lambda_function.exif_cleaner.arn
    events              = ["s3:ObjectCreated:*"]
  }
}


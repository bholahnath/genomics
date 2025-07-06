resource "aws_iam_user" "user_a" {
  name = var.user_a_name
}

resource "aws_iam_user_policy" "user_a_policy" {
  name = "${var.user_a_name}_policy"
  user = aws_iam_user.user_a.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = ["s3:GetObject", "s3:PutObject"],
      Effect = "Allow",
      Resource = ["${var.bucket_a_arn}/*"]
    }]
  })
}

resource "aws_iam_user" "user_b" {
  name = var.user_b_name
}

resource "aws_iam_user_policy" "user_b_policy" {
  name = "${var.user_b_name}_policy"
  user = aws_iam_user.user_b.name

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = ["s3:GetObject"],
      Effect = "Allow",
      Resource = ["${var.bucket_b_arn}/*"]
    }]
  })
}


### Role trust policy
data "aws_iam_policy_document" "this" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["${var.iam_role_aws_service}.amazonaws.com"]
    }
  }
}

## iam Role
resource "aws_iam_role" "this" {
  count = var.create_iam_role ? 1 : 0 
  name               = "${var.service_name}-role"
  # path               = "/system/"
  assume_role_policy = data.aws_iam_policy_document.this.json
  tags = var.tags
}

## IAM policy to allow full access to created RDS and S3
resource "aws_iam_policy" "this" {
  count = var.create_iam_policy ? 1 : 0 
  name        = "${var.service_name}-policy"
  #path        = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:*",
        ]
        Effect   = "Allow"
        Resource = "${aws_s3_bucket.this[*].arn}"
      },
      {
        Action = [
          "rds:*",
        ]
        Effect   = "Allow"
        Resource = "${aws_db_instance.this[*].arn}"
      },
    ]
  })
  tags = var.tags
}

## Attach policy
resource "aws_iam_policy_attachment" "test-attach" {
  count = var.attach_iam_policy ? 1 : 0 
  name       = "policy-attachment"
  roles      = [aws_iam_role.this[0].name]
  policy_arn = aws_iam_policy.this[0].arn
}



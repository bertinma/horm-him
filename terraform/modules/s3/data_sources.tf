data "aws_iam_policy_document" "this" {
  statement {
    effect = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.this.arn}/*"]
    principals {
      type = "*"
      identifiers = ["*"]
    }
  }
}

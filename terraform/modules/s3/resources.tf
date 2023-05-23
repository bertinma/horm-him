resource "aws_s3_bucket_versioning" "this" {
  bucket = aws_s3_bucket.this.id
  versioning_configuration {
    status = "Enabled"
  }
}


resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
}


resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  acl           = "private"
  force_destroy = true

  tags = var.default_tags

}

resource "aws_s3_bucket_policy" "website_bucket_policy" {
	bucket = aws_s3_bucket.this.id
	policy = data.aws_iam_policy_document.this.json
}


# Uploading files to S3.
resource "aws_s3_object" "this" {
  for_each = fileset("${path.module}/files/website/", "**/*")
  bucket   = aws_s3_bucket.this.id
  key      = each.value
  source   = "${path.module}/files/website/${each.value}"

  etag = filemd5("${path.module}/files/website/${each.value}")
}
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket" "this" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = var.default_tags

}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.this.id
  policy = jsonencode(
    {
      "Id" : "1",
      "Version" : "2012-10-17",
      "Statement" : [
        {
          "Sid" : "2",
          "Action" : [
            "s3:GetObject",
            "s3:ListBucket"
          ],
          "Effect" : "Allow",
          "Resource" : [
            aws_s3_bucket.this.arn,
            "${aws_s3_bucket.this.arn}/*",
          ]
          "Principal" : "*"
        },
        {
          "Effect" : "Allow",
          "Principal" : {
            "AWS" : var.lambda_role_arn
          },
          "Action" : [
            "s3:GetObject"
          ],
          "Resource" : [
            "arn:aws:s3:::${aws_s3_bucket.this.id}/${var.csv_file_name}"
          ]
        }
      ]
    }
  )
}


# Uploading files to S3.
resource "aws_s3_object" "html" {
  for_each     = fileset("${path.module}/files/website/", "**/*.html")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "text/html"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "svg" {
  for_each     = fileset("${path.module}/files/website/", "**/*.svg")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "image/svg+xml"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "css" {
  for_each     = fileset("${path.module}/files/website/", "**/*.css")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "text/css"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "js" {
  for_each     = fileset("${path.module}/files/website/", "**/*.js")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "application/javascript"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "png" {
  for_each     = fileset("${path.module}/files/website/", "**/*.png")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "image/png"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "jpeg" {
  for_each     = fileset("${path.module}/files/website/", "**/*.JPG")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "image/jpeg"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "json" {
  for_each     = fileset("${path.module}/files/website/", "**/*.json")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "application/json"

  etag = filemd5("${path.module}/files/website/${each.value}")
}

resource "aws_s3_object" "otf" {
  for_each     = fileset("${path.module}/files/website/", "**/*.otf")
  bucket       = aws_s3_bucket.this.id
  key          = each.value
  source       = "${path.module}/files/website/${each.value}"
  content_type = "application/x-font-opentype"

  etag = filemd5("${path.module}/files/website/${each.value}")
}
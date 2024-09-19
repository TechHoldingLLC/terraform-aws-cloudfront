resource "aws_s3_object" "object" {
  count = var.put_default_root_object ? 1 : 0

  bucket       = var.s3_bucket_name
  key          = "index.html"
  source       = "${path.cwd}/${path.module}/s3/index.html"
  content_type = "text/html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("${path.cwd}/${path.module}/s3/index.html")
}
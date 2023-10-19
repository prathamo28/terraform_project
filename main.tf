resource "aws_s3_bucket" "alt_s3_database_backup" {
  for_each = { for idx, name in var.bucket_names : idx => name }
  bucket   = each.value
}

resource "aws_s3_bucket" "alt_s3_database_backup" {
  for_each = { for idx, name in var.bucket_names : idx => name }
  bucket   = each.value
}

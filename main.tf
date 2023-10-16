
data "aws_iam_policy_document" "alt_backup_key_policy" {
  statement {
    sid       = "Enable IAM User Permissions"
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
    ]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${var.Account_id}:root"]
    }
  }
}

resource "aws_kms_key" "alt_backup_test" {
  description = "Alt-Backup-key-for-s3-test-bucket"
  policy      = data.aws_iam_policy_document.alt_backup_key_policy.json
}

resource "aws_kms_key" "alt_backup_prod" {
  description = "Alt-Backup-key-for-s3-Prod-buckets"
  policy      = data.aws_iam_policy_document.alt_backup_key_policy.json
}


#Creating S3 buckets
resource "aws_s3_bucket" "alt_s3_database_backup_test" {
  bucket = "alt-s3-database-backup-test-v1"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_database_backup_test_encryption" {
  bucket = aws_s3_bucket.alt_s3_database_backup_test.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.alt_backup_test.id
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "alt_s3_database_backup_prod" {
  bucket = "alt-s3-database-backup-prod-v1"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_database_backup_prod_encryption" {
  bucket = aws_s3_bucket.alt_s3_database_backup_prod.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.alt_backup_prod.id
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "alt_s3_app_backup_test" {
  bucket = "alt-s3-app-backup-test-v1"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_app_backup_test_encryption" {
  bucket = aws_s3_bucket.alt_s3_database_backup_test.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.alt_backup_test.id
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "alt_s3_app_backup_prod" {
  bucket = "alt-s3-app-backup-prod-v1"
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_app_backup_prod_encryption" {
  bucket = aws_s3_bucket.alt_s3_database_backup_prod.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.alt_backup_prod.id
      sse_algorithm = "aws:kms"
    }
  }
}




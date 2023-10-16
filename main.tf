# create iam role and policy 
data "aws_iam_policy_document" "s3_assume_policy" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["s3.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "s3_backup_policy" {
  name = "alt-vault-s3-backup-role"
  assume_role_policy = "${data.aws_iam_policy_document.s3_assume_policy.json}"
}

#Createing s3 buckets 
resource "aws_s3_bucket" "alt_s3_database_backup_test_v1" {
  bucket = "alt-s3-database-backup-test-v1"
  acl    = "private"
  tags = {
    Name = "alt-s3-database-backup-test-v1"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_s3_database_test_encryption" {
  bucket = aws_s3_bucket.alt_s3_database_backup_test_v1.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backup_test_key.arn
      sse_algorithm = "aws:kms"
    }
  }
}


resource "aws_s3_bucket" "alt_s3_database_backup_prod_v1" {
  bucket = "alt-s3-database-backup-prod-v1"
  acl    = "private"
  tags = {
    Name = "alt-s3-database-backup-prod-v1"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_s3_database_prod_encryption" {
  bucket = aws_s3_bucket.alt_s3_database_backup_prod_v1.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backup_prod_key.arn
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "alt_s3_app_backup_test_v1" {
  bucket = "alt-s3-app-backup-test-v1"
  acl    = "private"
  tags = {
    Name = "alt-s3-app-backup-test-v1"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_s3_app_test_encryption" {
  bucket = aws_s3_bucket.alt_s3_app_backup_test_v1.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backup_test_key.arn
      sse_algorithm = "aws:kms"
    }
  }
}

resource "aws_s3_bucket" "alt_s3_app_backup_prod_v1" {
  bucket = "alt-s3-app-backup-prod-v1"
  acl    = "private"
  tags = {
    Name = "alt-s3-app-backup-prod-v1"
  }
}
resource "aws_s3_bucket_server_side_encryption_configuration" "alt_s3_app_prod_encryption" {
  bucket = aws_s3_bucket.alt_s3_app_backup_prod_v1.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.backup_prod_key.arn
      sse_algorithm = "aws:kms"
    }
  }
}

#Creating commone kms key for test and prod
resource "aws_kms_key" "backup_test_key" {
  description             = "KMS key for alt-s3-database-backup-test-v1"
}

resource "aws_kms_key" "backup_prod_key" {
  description             = "KMS key for alt-s3-database-backup-prod-v1"
}

#Creating bucket policy for each bucket 
//database-test-bucket
data "aws_iam_policy_document" "allow_org_to_database_test_policy" {
  statement {
    sid       = "AllowOrgAndAltrata"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-database-backup-test-v1/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["arn:aws:iam::YOUR-ORG-ID-HERE:root"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "AllowBackupRole"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-database-backup-test-v1/*"]
    actions   = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::YOUR-ROLE-ARN-HERE"]
    }
  }
}

resource "aws_s3_bucket_policy" "database_backup_test_policy" {
  bucket = aws_s3_bucket.alt_s3_database_backup_test_v1.id
  policy = data.aws_iam_policy_document.allow_org_to_database_test_policy.json
}

// database-prod-bucket 
data "aws_iam_policy_document" "allow_org_to_database_prod_policy" {
  statement {
    sid       = "AllowOrgAndAltrata"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-database-backup-prod-v1/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["arn:aws:iam::YOUR-ORG-ID-HERE:root"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "AllowBackupRole"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-database-backup-prod-v1/*"]
    actions   = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::YOUR-ROLE-ARN-HERE"]
    }
  }
}

resource "aws_s3_bucket_policy" "database_backup_prod_policy" {
  bucket = aws_s3_bucket.alt_s3_database_backup_prod_v1.id
  policy = data.aws_iam_policy_document.allow_org_to_database_prod_policy.json
}

//app-test-bucket
data "aws_iam_policy_document" "allow_org_to_app_test_policy" {
  statement {
    sid       = "AllowOrgAndAltrata"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-app-backup-test-v1/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["arn:aws:iam::YOUR-ORG-ID-HERE:root"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "AllowBackupRole"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-app-backup-test-v1/*"]
    actions   = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::YOUR-ROLE-ARN-HERE"]
    }
  }
}

resource "aws_s3_bucket_policy" "app_backup_test_policy" {
  bucket = aws_s3_bucket.alt_s3_app_backup_test_v1.id
  policy = data.aws_iam_policy_document.allow_org_to_app_test_policy.json
}

//app-prod-bucket
data "aws_iam_policy_document" "allow_org_to_app_prod_policy" {
  statement {
    sid       = "AllowOrgAndOU"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-app-backup-prod-v1/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["arn:aws:iam::YOUR-ORG-ID-HERE:root"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }

  statement {
    sid       = "AllowBackupRole"
    effect    = "Allow"
    resources = ["arn:aws:s3:::alt-s3-app-backup-prod-v1/*"]
    actions   = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::YOUR-ROLE-ARN-HERE"]
    }
  }
}

resource "aws_s3_bucket_policy" "app_backup_prod_policy" {
  bucket = aws_s3_bucket.alt_s3_app_backup_prod_v1.id
  policy = data.aws_iam_policy_document.allow_org_to_app_prod_policy.json
}


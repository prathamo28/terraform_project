data "aws_iam_policy_document" "altrata_test_policy" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "kms:DescribeKey",
      "kms:Decrypt",
      "kms:Encrypt",
      "kms:GenerateDataKey",
      "kms:ReEncrypt*",
    ]

    condition {
      test     = "StringLike"
      variable = "kms:ViaService"
      values   = ["s3.*.amazonaws.com"]
    }
  }

  statement {
    sid    = ""
    effect = "Allow"

    resources = [
      "arn:aws:s3:::*",
      "arn:aws:s3:::*/*",
    ]

    actions = [
      "s3:GetInventoryConfiguration",
      "s3:PutInventoryConfiguration",
      "s3:ListBucketVersions",
      "s3:ListBucket",
      "s3:GetBucketNotification",
      "s3:PutBucketNotification",
      "s3:GetBucketLocation",
      "s3:GetBucketTagging",
      "s3:GetBucketAcl",
      "s3:CreateBucket",
      "s3:GetBucketVersioning",
      "s3:PutBucketVersioning",
      "s3:GetObjectAcl",
      "s3:GetObject",
      "s3:GetObjectVersionTagging",
      "s3:GetObjectVersionAcl",
      "s3:GetObjectTagging",
      "s3:GetObjectVersion",
      "s3:DeleteObject",
      "s3:PutObjectVersionAcl",
      "s3:GetObjectVersionAcl",
      "s3:PutObjectTagging",
      "s3:PutObjectAcl",
      "s3:PutObject",
      "s3:ListMultipartUploadParts",
    ]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["s3:ListAllMyBuckets"]
  }

  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["arn:aws:events:*:*:rule/AwsBackupManagedRule*"]

    actions = [
      "events:DescribeRule",
      "events:EnableRule",
      "events:PutRule",
      "events:DeleteRule",
      "events:PutTargets",
      "events:RemoveTargets",
      "events:ListTargetsByRule",
      "events:DisableRule",
      "cloudwatch:GetMetricData",
      "events:ListRules",
    ]
  }
}

resource "aws_iam_policy" "alt_new_policy" {
  name = "alt-get-policy"
  policy = "${data.aws_iam_policy_document.altrata_test_policy.json}"
}

data "aws_iam_policy_document" "alt_test_role" {
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "alt_assume_role" {
  name = "alt-assume-role"
  assume_role_policy = "${data.aws_iam_policy_document.alt_test_role.json}"
}

resource "aws_iam_role_policy_attachment" "alt_ops_backup_role_attachment" {
  policy_arn = aws_iam_policy.alt_new_policy.arn
  role       = [aws_iam_role.alt_assume_role.name]
}
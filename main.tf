
data "aws_iam_policy_document" "hello" {
  statement {
    sid       = "AllowPutFromOrganizationAndAltrataOU"
    effect    = "Allow"
    resources = ["arn:aws:s3:::example-bucket-name/*"]
    actions   = ["s3:PutObject"]

    condition {
      test     = "StringEquals"
      variable = "aws:PrincipalOrgID"
      values   = ["o-15zuuzur24"]
    }

    principals {
      type        = "*"
      identifiers = ["*"]
    }
  }
}


resource "aws_s3_bucket" "example_bucket" {
  bucket = "example-bucket-name"
}

resource "aws_s3_bucket_policy" "allow_access_from_another_account" {
  bucket = aws_s3_bucket.example_bucket.id
  policy = data.aws_iam_policy_document.hello.json
}



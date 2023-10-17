data "aws_organizations_organization" "current" {}

data "aws_organizations_organizational_units" "altrata_ou" {
  parent_id = data.aws_organizations_organization.current.roots[0].id
}

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
  policy = data.aws_iam_policy_document.hello.json

}




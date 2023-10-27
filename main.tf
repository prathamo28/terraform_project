data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["backup.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}
resource "aws_iam_role" "alt_vault_role" {
  name               = "vault-role"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "example" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.alt_vault_role.name
}




# KMS Key for Vault
resource "aws_kms_key" "alt_vault_thirty_day_key" {
  count      = length(var.regions)
  description = "alt-vault-thirty-day-retention-key"
  key_usage = "ENCRYPT_DECRYPT"
}
resource "aws_kms_alias" "alt_vault_thirty_day" {
  name = "alias/alt-vault-day-${var.regions[count.index]}"
  target_key_id = aws_kms_key.alt_vault_thirty_day_key.key_id
}

resource "aws_kms_key" "alt_vault_six_month_key" {
  count      = length(var.regions)
  description = "alt-vault-six-month-retention-key"
  key_usage = "ENCRYPT_DECRYPT"
}
resource "aws_kms_alias" "alt_vault_six_month" {
  name = "alias/alt-vault-month-${var.regions[count.index]}"
  target_key_id = aws_kms_key.alt_vault_six_month_key.key_id
}

# Create aws backup vault in alt-secure account 
resource "aws_backup_vault" "thirty_day_retention_vault" {
  count       = length(var.regions)
  name        = "alt-vault-thirty-day-retention-v1-${var.regions[count.index]}"
  kms_key_arn = aws_kms_key.alt_vault_thirty_day_key.arn
}
resource "aws_backup_vault_lock_configuration" "alt_backup_day_lock" {
  count               = length(var.regions)
  backup_vault_name   = "alt-vault-twenty-day-retention-v1-${var.regions[count.index]}"
  min_retention_days  = 7
  max_retention_days  = 30
}

resource "aws_backup_vault" "six_month_retention_vault" {
  count       = length(var.regions)
  name        = "alt-vault-six-month-retention-v1-${var.regions[count.index]}"
  kms_key_arn = aws_kms_key.alt_vault_six_month_key.arn
}
resource "aws_backup_vault_lock_configuration" "alt_backup_month_lock" {
  count               = length(var.regions)
  backup_vault_name   = "alt-vault-six-month-retention-v1-${var.regions[count.index]}"
  min_retention_days  = 90
  max_retention_days  = 180
}





















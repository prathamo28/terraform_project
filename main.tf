
# KMS Key for Vault
resource "aws_kms_key" "alt_vault_thirty_day_key" {
  for_each    = var.regions
  description = "alt-vault-thirty-day-retention-key"
  key_usage   = "ENCRYPT_DECRYPT"
}
resource "aws_kms_alias" "alt_vault_thirty_day" {
  for_each      = aws_kms_key.alt_vault_thirty_day_key
  name          = "alias/alt-vault-day-${each.key}"
  target_key_id = aws_kms_key.alt_vault_thirty_day_key.key_id
}

resource "aws_kms_key" "alt_vault_six_month_key" {
  for_each    = var.regions
  description = "alt-vault-six-month-retention-key"
  key_usage   = "ENCRYPT_DECRYPT"
}
resource "aws_kms_alias" "alt_vault_six_month" {
  for_each      = aws_kms_key.alt_vault_six_month_key
  name          = "alias/alt-vault-month-${each.key}"
  target_key_id = aws_kms_key.alt_vault_six_month_key.key_id
}

# Create aws backup vault in alt-secure account 
resource "aws_backup_vault" "thirty_day_retention_vault" {
  for_each    = aws_kms_key.alt_vault_thirty_day_key
  name        = "alt-vault-thirty-day-retention-v1-${var.regions[count.index]}"
  kms_key_arn = aws_kms_key.alt_vault_thirty_day_key.arn
}
resource "aws_backup_vault_lock_configuration" "alt_backup_day_lock" {
  for_each            = aws_kms_key.alt_vault_thirty_day_key
  backup_vault_name   = "alt-vault-twenty-day-retention-v1-${var.regions[count.index]}"
  min_retention_days  = 7
  max_retention_days  = 30
}

resource "aws_backup_vault" "six_month_retention_vault" {
  for_each    = aws_kms_key.alt_vault_six_month_key
  name        = "alt-vault-six-month-retention-v1-${var.regions[count.index]}"
  kms_key_arn = aws_kms_key.alt_vault_six_month_key.arn
}
resource "aws_backup_vault_lock_configuration" "alt_backup_month_lock" {
  for_each            = aws_kms_key.alt_vault_six_month_key
  backup_vault_name   = "alt-vault-six-month-retention-v1-${var.regions[count.index]}"
  min_retention_days  = 90
  max_retention_days  = 180
}





















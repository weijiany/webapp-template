resource "azurerm_key_vault_secret" "secrets" {
  for_each = var.secrets
  key_vault_id = var.key_vault_id
  name = each.key
  value = each.value
}
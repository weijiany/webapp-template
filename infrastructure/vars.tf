variable "authentication" {
  type = object({
    client_id                   = string
    subscription_id             = string
    tenant_id                   = string
    client_certificate_password = string
  })
}
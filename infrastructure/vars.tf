variable "authentication" {
  type = object({
    client_id       = string
    subscription_id = string
    tenant_id       = string
    client_secret   = string
    object_id       = string
  })
}

variable "sql_server" {
  type = object({
    username = string
    password = string
  })
}

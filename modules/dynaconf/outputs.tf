output "configmap_name" {
  value = kubernetes_config_map.default.metadata[0].name
}

output "secret_name" {
  value = kubernetes_secret.default.metadata[0].name
}

output "secret_revision" {
  value = md5(jsonencode(kubernetes_secret.default.data))
}

output "config_revision" {
  value = md5(jsonencode(kubernetes_config_map.default.data))
}

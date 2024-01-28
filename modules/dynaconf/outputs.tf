output "configmap_name" {
  value = kubernetes_config_map.dynaconf.metadata[0].name
}

output "secret_name" {
  value = kubernetes_secret.dynaconf.metadata[0].name
}

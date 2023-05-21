resource "kubernetes_config_map" "main" {
  count = contains(["server", "command", "worker", "cron"], var.role) ? 1 : 0
  metadata {
    namespace = var.namespace
    name      = var.name
  }

  data = {
    "settings.yaml" = var.config
  }
}

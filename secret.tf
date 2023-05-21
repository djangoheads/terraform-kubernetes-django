resource "kubernetes_secret" "main" {
  count = contains(["server", "command", "worker", "cron"], var.role) ? 1 : 0
  metadata {
    namespace = var.namespace
    name = var.name
  }

  data = { 
    "secrets.yaml" = var.secrets
  }
}
resource "kubernetes_persistent_volume_claim" "default" {
  count = var.persistence_enabled ? 1 : 0

  metadata {
    name = var.name
    namespace = var.namespace
  }

  spec {
    storage_class_name = "gp2"
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "10Gi"
      }
    }
  }
}

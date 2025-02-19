

resource "kubernetes_config_map" "default" {
  metadata {
    namespace = var.namespace
    name      = "${var.name}-settings"
  }

  data = {
    ".env" = var.defaultconf.settings
  }
}


resource "kubernetes_secret" "default" {
  metadata {
    namespace = var.namespace
    name      = "${var.name}-settings"
  }

  data = {
    ".secrets" = var.defaultconf.secrets
  }
}

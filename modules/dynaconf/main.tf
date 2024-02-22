

resource "kubernetes_config_map" "default" {
  metadata {
    namespace = var.namespace
    name      = "${var.name}-dynaconf"
  }

  data = {
    "override.yaml" = var.dynaconf.settings
  }
}


resource "kubernetes_secret" "default" {
  metadata {
    namespace = var.namespace
    name      = "${var.name}-dynaconf"
  }

  data = {
    ".secrets.yaml" = var.dynaconf.secrets
  }
}

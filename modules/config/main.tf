

resource "kubernetes_config_map" "dynaconf" {
  metadata {
    namespace = var.namespace
    name      = var.name + "-dynaconf"
  }

  data = {
    "settings.yaml" = var.dynaconf.settings
  }
}


resource "kubernetes_secret" "dynaconf" {
  metadata {
    namespace = var.namespace
    name      = var.name + "-dynaconf"
  }

  data = {
    ".secrets.yaml" = var.dynaconf.secrets
  }
}
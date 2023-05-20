resource "kubernetes_job" "command" {
  count = var.role == "command" ? 1 : 0
  metadata {
    namespace = var.namespace
    name = var.name
  }
  spec {
    template {
      metadata {}
      spec {
        container {
          name = "main"
          image = "${var.image.name}:${var.image.tag}:"
          command = var.command
        }
        restart_policy = "Never"
      }
    }
  }
  wait_for_completion = var.wait
}
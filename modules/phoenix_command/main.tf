resource "kubernetes_job" "default" {
  metadata {
    namespace = var.namespace
    name      = var.name
    labels    = var.labels
  }
  spec {
    ttl_seconds_after_finished = 100
    backoff_limit              = var.backoff_limit
    active_deadline_seconds    = var.active_deadline_seconds
    template {
      metadata {
        labels = merge({
          service         = var.name
          config_revision = var.config_revision
          secret_revision = var.secret_revision
        }, var.labels)
      }
      spec {
        service_account_name = var.service_account_name

        container {
          name              = "main"
          image             = var.image
          command           = var.command
          args              = var.args
          image_pull_policy = var.image_pull_policy
          working_dir       = var.working_dir
          resources {
            limits   = length(var.limits) > 0 ? var.limits : null
            requests = length(var.requests) > 0 ? var.requests : null
          }
          dynamic "env" {
            for_each = var.env_vars
            content {
              name  = env.key
              value = env.value
            }
          }

          # Mounts
          env_from {
            config_map_ref {
              name = var.configmap_name
            }
          }
          env_from {
            secret_ref {
              name = var.secret_name
            }
          }
        }
        restart_policy = "Never"
      }
    }
  }
  wait_for_completion = var.wait

  timeouts {
    create = var.timeout
    update = var.timeout
  }
}

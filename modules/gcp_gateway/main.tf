locals {
  labels = merge(
    {
      managed_by = "terraform"
    },
    var.labels
  )

  routes = {
    for index, rule in var.rules :
    format("%02d-%s", index, rule.host) => rule
  }

  route_names = {
    for key, rule in local.routes :
    key => substr("${var.name}-${replace(replace(lower(rule.host), "/^\\*\\./", "wildcard-"), "/[^a-z0-9-]/", "-")}", 0, 63)
  }

  health_check_names = {
    for service_name in keys(var.health_checks) :
    service_name => substr("${var.name}-${replace(lower(service_name), "/[^a-z0-9-]/", "-")}-health", 0, 63)
  }
}

resource "kubernetes_manifest" "gateway" {
  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "Gateway"
    metadata = {
      name      = var.name
      namespace = var.namespace
      labels    = local.labels
      annotations = merge({
        "networking.gke.io/certmap" = var.certificate_map_name
      }, var.annotations)
    }
    spec = {
      gatewayClassName = var.gateway_class_name
      listeners = [
        {
          name     = "https"
          protocol = "HTTPS"
          port     = 443
          allowedRoutes = {
            namespaces = {
              from = "Same"
            }
          }
        }
      ]
    }
  }
}

resource "kubernetes_manifest" "http_route" {
  for_each = local.routes

  manifest = {
    apiVersion = "gateway.networking.k8s.io/v1"
    kind       = "HTTPRoute"
    metadata = {
      name      = local.route_names[each.key]
      namespace = var.namespace
      labels    = local.labels
    }
    spec = {
      parentRefs = [
        {
          group = "gateway.networking.k8s.io"
          kind  = "Gateway"
          name  = var.name
        }
      ]
      hostnames = [each.value.host]
      rules = [
        for path in each.value.paths : {
          matches = [
            {
              path = {
                type  = "PathPrefix"
                value = path.path
              }
            }
          ]
          backendRefs = [
            {
              group = ""
              kind  = "Service"
              name  = path.backend.service
              port  = path.backend.port
            }
          ]
        }
      ]
    }
  }

  depends_on = [kubernetes_manifest.gateway]
}

resource "kubernetes_manifest" "health_check_policy" {
  for_each = var.health_checks

  manifest = {
    apiVersion = "networking.gke.io/v1"
    kind       = "HealthCheckPolicy"
    metadata = {
      name      = local.health_check_names[each.key]
      namespace = var.namespace
      labels    = local.labels
    }
    spec = {
      default = {
        checkIntervalSec   = each.value.check_interval_sec
        timeoutSec         = each.value.timeout_sec
        healthyThreshold   = each.value.healthy_threshold
        unhealthyThreshold = each.value.unhealthy_threshold
        logConfig = {
          enabled = each.value.log_enabled
        }
        config = {
          type = "HTTP"
          httpHealthCheck = {
            portSpecification = "USE_FIXED_PORT"
            port              = each.value.port
            requestPath       = each.value.request_path
          }
        }
      }
      targetRef = {
        group = ""
        kind  = "Service"
        name  = each.key
      }
    }
  }
}

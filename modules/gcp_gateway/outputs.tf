output "gateway_name" {
  value       = var.name
  description = "Gateway resource name."
}

output "gateway_address" {
  value       = try(kubernetes_manifest.gateway.object.status.addresses[0].value, null)
  description = "Gateway load balancer IP address after GKE programs it."
}

output "http_route_names" {
  value       = values(local.route_names)
  description = "HTTPRoute resource names."
}

output "health_check_policy_names" {
  value       = values(local.health_check_names)
  description = "HealthCheckPolicy resource names."
}

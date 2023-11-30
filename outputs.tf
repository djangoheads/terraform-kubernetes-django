
output "service_name" {
  value       = var.name
  description = "Service name that should be exposed to internet, needed for ingress"
}

output "aws_certificate_record_name" {
  value       = one(tolist(aws_ingress.aws_acm_certificate.truely-cert[0].domain_validation_options)[1].resource_record_name)
}

output "aws_certificate_record_value" {
  value       = one(tolist(aws_ingress.aws_acm_certificate.truely-cert[0].domain_validation_options)[1].resource_record_value)
}

output "aws_ingress_hostname" {
  value       = one(aws_ingress.kubernetes_ingress_v1.main[0].status[0].load_balancer[0].ingress[0].hostname)
}

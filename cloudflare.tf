resource "aws_acm_certificate" "main-cert" {
  count             = var.role == "cloudflare" ? 1 : 0
  domain_name       = var.acm_cert_domain_name
  validation_method = "DNS"

  subject_alternative_names = var.acm_cert_alternative_names
  options {
    certificate_transparency_logging_preference = "ENABLED"
  }

  tags = local.default_tags
}

resource "cloudflare_record" "cert" {
  count      = var.role == "cloudflare" ? 1 : 0
  depends_on = [aws_acm_certificate.main-cert]
  zone_id    = var.cloudflare_zone_id
  name       = tolist(aws_acm_certificate.main-cert[0].domain_validation_options)[1].resource_record_name
  value      = tolist(aws_acm_certificate.main-cert[0].domain_validation_options)[1].resource_record_value
  type       = "CNAME"
  proxied    = false
}

resource "cloudflare_record" "backend" {
  count      = var.role == "ingress" ? 1 : 0
  depends_on = [kubernetes_ingress_v1.main]
  zone_id    = var.cloudflare_zone_id
  name       = "backend-dev-private"
  value      = kubernetes_ingress_v1.main[0].status[0].load_balancer[0].ingress[0].hostname
  type       = "CNAME"
  proxied    = true
}

resource "cloudflare_filter" "protect-private-subdomains" {
  count       = var.role == "cloudflare" ? 1 : 0
  description = "Protect Private Subdomains"
  zone_id     = var.cloudflare_zone_id
  expression  = "(not ip.src in ${local.vpn-ip} and http.host contains \"-private.main.dev\")"
}

resource "cloudflare_firewall_rule" "protect-private-subdomains" {
  count       = var.role == "cloudflare" ? 1 : 0
  description = "Protect Private Subdomains"
  priority    = 200
  zone_id     = var.cloudflare_zone_id
  filter_id   = cloudflare_filter.protect-private-subdomains[0].id
  action      = "block"
}

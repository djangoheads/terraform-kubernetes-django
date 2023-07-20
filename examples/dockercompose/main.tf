

module "django" {
  for_each = local.docker-compose["services"]
  source = "../dummy"
  conf = each.value
}
locals {
  config = file("${path.module}/${var.config}")
  secrets = file("${path.module}/${var.secrets}")
}
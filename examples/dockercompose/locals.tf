locals {
  docker-compose = yamldecode(file(var.docker-compose))
}

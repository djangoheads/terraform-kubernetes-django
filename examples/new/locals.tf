locals {
  namespace = "minikube"
  name      = "docker"
  config  = file("${path.module}/data/config.yaml")
  secrets = file("${path.module}/data/secrets.encrypted.yaml")
  docker_compose_yaml = file("${path.module}/dummy/docker-compose.yml")
  services_config     = yamldecode(local.docker_compose_yaml)["services"]
  env_file_content = file("${path.module}/dummy/docker-compose.env")
  
  env_vars = { for tuple in regexall("(.*)=(.*)", local.env_file_content) : tuple[0] => tuple[1] }
}
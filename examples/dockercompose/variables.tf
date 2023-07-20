variable "docker-compose" {
  type    = string
  default = "docker-compose.yml"
}

variable "exclude-services" {
  type    = list(string)
  default = ["build", "storage"]
}

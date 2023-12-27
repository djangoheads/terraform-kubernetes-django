variable "namespace" {
  type = string
  default = "default"
}

variable "name" {
  type = string
  default = "django"
}

variable "config" {
  type = string
  default = "./data/config.yaml"
}

variable "secrets" {
  type = string
  default = "./data/secrets.encrypted.yaml"
}

variable "image" {
  type = string
  default = "djangoheads/dummy:latest"
}

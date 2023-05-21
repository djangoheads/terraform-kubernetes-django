variable "namespace" {
  type = string
  default = "simple-namespace"
}

variable "name" {
  type = string
  default = "simple-service"
}

variable "image" {
  type = object({
    name = string
    tag = string
  })
  default = {
    name = "simple/image"
    tag = "version"
  }
}

variable "config" {
  type = string
  default = "data/config.yaml"
}

variable "secrets" {
  type = string
  default = "data/secrets.encrypted.yaml"
}
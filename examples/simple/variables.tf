variable "namespace" {
  type = string
  default = "dummy-namespace"
}

variable "name" {
  type = string
  default = "example-name"
}

variable "image" {
  type = object({
    name = string
    tag = string
  })
  default = {
    name = "image/name"
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
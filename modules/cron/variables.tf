variable "namespace" {
    type = string
}

variable "name" {
    type = string
}

variable "dynaconf" {
  type = object({
    settings = string
    secrets = string
  })
}

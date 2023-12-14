variable "namespace" {
  type = string
}

variable "name" {
  type = string
}

variable "config" {
  type = string
}

variable "secrets" {
  type = string
}

variable "image" {
  type = object({
    name = string
    tag  = string
  })
}

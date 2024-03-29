variable "namespace" {
    type = string
}

variable "name" {
    type = string
}
# Ingress Specific Variables

variable "rules" {
  type = list(object({
    host = string
    paths = list(object({
      path = string
      backend = object({
        service = string
        port    = number
      })
    }))
  }))
  default = [{
    host = "*"
    paths = [{
      path = "/"
      backend = {
        service = 8000
        port    = 80
      }
    }]
  }]
  description = "Ingress rules to be created"
}




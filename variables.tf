variable "role" {
  type = string 
  validation {
    condition = contains(["ingress", "server", "command", "worker", "cron"], var.role)
    error_message = "${var.role} must be one of: server, command, worker, cron"
  }
}

variable "namespace" {
  type = string
} 

variable "name" {
  type = string
} 

variable "image" {
  type = object({
    name = string
    tag = string
  })
  default = {
    name = null
    tag = "latest"
  }
}

variable "command" {
  type = list(string)
  default = []
}

variable "config" {
  type = string
  default = ""
  validation {
    condition = length(yamldecode(var.config)) >= 1
    error_message = "Check config file ${var.config}, it's invalid or empty"
  }
}

variable "secrets" {
  type = string
  default = ""
  sensitive = true
  validation {
    condition = length(yamldecode(var.secrets)) >= 1
    error_message = "Check config file ${var.secrets}, it's invalid or empty"
  }
}

variable "wait" {
  type = bool
  default = true
}

###########
# COMMAND #
###########



##########
# SERVER #
##########

variable "replicas" {
  type = object({
    min = number
    max = number
  })
  default = {
    min = 3
    max = -1
  }
}

variable "port" {
  type = number
  default = 8000
}

variable "readiness" {
  type = object({
    delay = number
    port = number
    path = string
  })
  default = {
    delay = 10
    port = 8000
    path = "/health-check"
  }
}

variable "liveness" {
  type = object({
    delay = number
    port = number
    path = string
  })
  default = {
    delay = 60
    port = 8000
    path = "/health-check"
  }
}

###########
# INGRESS #
###########

variable "ingress" {
  type = list(object({
    host = string
    paths = list(object({
      path = string
      backend = object({
        service = string
        port = number
      })
    }))
  }))
  default = [{
    host = "*"
    paths = [{
      path = "/"
      backend = {
        service = null
        port = 80
      }
    }]
  }]
}
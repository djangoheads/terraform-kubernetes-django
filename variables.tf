variable "role" {
  type = string 
  validation {
    condition = contains(["server", "command", "worker", "cron"], var.role)
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
}

variable "command" {
  type = list(string)
  default = []
}

variable "config" {
  type = string
  validation {
    condition = length(yamldecode(var.config)) >= 1
    error_message = "Check config file ${var.config}, it's invalid or empty"
  }
}

variable "secrets" {
  type = string
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

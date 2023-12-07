variable "role" {
  type        = string
  description = "The main role of component, can be ingress, server, command, worker, cron"
  validation {
    condition     = contains(["ingress", "server", "command", "worker", "cron"], var.role)
    error_message = "${var.role} must be one of: server, command, worker, cron"
  }
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace"
}

variable "name" {
  type        = string
  description = "Main name in K8S resources"
}

variable "image" {
  type        = string
  description = "image"
  default     = ""
}

variable "command" {
  type        = list(string)
  default     = []
  description = "Override command"
}

variable "init_command" {
  type        = list(string)
  default     = []
  description = "Override command"
}

variable "args" {
  type        = list(string)
  default     = []
  description = "Override command"
}

variable "config" {
  type    = string
  default = ""
  validation {
    condition     = length(yamldecode(var.config)) >= 1
    error_message = "Check config file ${var.config}, it's invalid or empty"
  }
  description = "Django Configuration"
}

variable "secrets" {
  type      = string
  default   = ""
  sensitive = true
  validation {
    condition     = length(yamldecode(var.secrets)) >= 1
    error_message = "Check config file ${var.secrets}, it's invalid or empty"
  }
  description = "Django Secret Configuration"
}

variable "wait" {
  type        = bool
  default     = true
  description = "Perform waiting resource to be available and run"
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
    min = 1
    max = 1
  }
  description = "Define scalability options"
}

variable "port" {
  type        = number
  default     = 8000
  description = "Port to expose"
}
variable "target_port" {
  type        = number
  default     = 8000
  description = "Port to expose"
}

variable "readiness" {
  type = object({
    delay = number
    port  = number
    path  = string
  })
  default = {
    delay = 10
    port  = 8000
    path  = "/health-check"
  }
  description = "Readiness rules for Server"
}

variable "liveness" {
  type = object({
    delay = number
    port  = number
    path  = string
  })
  default = {
    delay = 60
    port  = 8000
    path  = "/health-check"
  }
  description = "Liveness rules for Server"
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
        port    = number
      })
    }))
  }))
  default = [{
    host = "*"
    paths = [{
      path = "/"
      backend = {
        service = null
        port    = 80
      }
    }]
  }]
  description = "Ingress configuration"
}
variable "env_vars" {
  description = "Environment variables for the storage module"
  type        = map(string)
  default     = {}
}


variable "actions_webhook_value" {
  type    = string
  default = "webhook"
}

variable "acm_cert_domain_name" {
  type    = string
  default = "domain.com"
}

variable "acm_cert_alternative_names" {
  type = list(any)
  default = [
    "domain"
  ]
}

variable "ip" {
  type    = string
  default = "0.0.0.0"
}

variable "default_tags" {
  type = map(string)
  default = {
    Environment = "development" 
    Managed     = "terraform"
  }
  
}
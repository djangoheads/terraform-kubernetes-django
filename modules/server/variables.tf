# Common variables

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

# Server specific variables

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

variable "args" {
  type        = list(string)
  default     = []
  description = "Override command"
}

variable "wait" {
  type        = bool
  default     = true
  description = "Perform waiting resource to be available and run"
}

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
variable "env_vars" {
  description = "Environment variables for the storage module"
  type        = map(string)
  default     = {}
}
variable "init_command" {
  type        = list(string)
  default     = []
  description = "Override command"
}
variable "settings_mount_path" {
  type = string
  default = "/var/etc/config"
}
variable "secrets_mount_path" {
  type = string
  default = "/var/etc/secrets"
}

variable "image_pull_policy" {
  type        = string
  default     = "IfNotPresent"
  description = "Image pull policy"
}

# variable "readiness" {
#   type = object({
#     delay = number
#     port  = number
#     path  = string
#   })
#   default = {
#     delay = 10
#     port  = 8000
#     path  = "/health-check"
#   }
#   description = "Readiness rules for Server"
# }

# variable "liveness" {
#   type = object({
#     delay = number
#     port  = number
#     path  = string
#   })
#   default = {
#     delay = 60
#     port  = 8000
#     path  = "/health-check"
#   }
#   description = "Liveness rules for Server"
# }
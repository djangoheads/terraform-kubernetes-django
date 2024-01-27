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

variable "replica_count" {
  type        = number
  default     = 1
  description = "Number of replicas"
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

variable "readiness" {
  type = list(object({
    initial_delay_seconds = optional(number)
    period_seconds = optional(number)
    timeout_seconds = optional(number)
    failure_threshold = optional(number)
    success_threshold = optional(number)
    http_get = optional(list(object({
      path    = optional(string)
      port    = optional(number)
    })))
  }))
  default = []
}

variable "liveness" {
  type = list(object({
    initial_delay_seconds = optional(number)
    period_seconds = optional(number)
    timeout_seconds = optional(number)
    failure_threshold = optional(number)
    success_threshold = optional(number)
    http_get = optional(list(object({
      path    = optional(string)
      port    = optional(number)
    })))
  }))
  default = []
}

variable "enable_autoscaler" {
  description = "Boolean flag to enable/disable kubernetes horizontal pod autoscaler"
  type        = bool
  default     = false
}

variable "cpu_target" {
  description = "Target CPU utilization percentage"
  type        = number
  default     = 110
}

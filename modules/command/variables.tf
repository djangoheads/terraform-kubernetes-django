# Common variables

variable "namespace" {
    type = string
}

variable "name" {
    type = string
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
variable "env_vars" {
  description = "Environment variables for the storage module"
  type        = map(string)
  default     = {}
}

variable "configmap_name" {
  type        = string
  description = "Configmap name"
  default     = null
}

variable "secret_name" {
  type        = string
  description = "Secret name"
  default     = null
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

variable "configmap_key" {
  type = string
  default = null
  description = "The key of the configmap to be used as the configuration for the application"
}

variable "configmap_path" {
  type = string
  default = null
  description = "The path where the configmap will be mounted"
}

variable "secret_key" {
  type = string
  default = null
  description = "The key of the secret to be used as the configuration for the application"
}

variable "secret_path" {
  type = string
  default = null
  description = "The path where the secret will be mounted"
}

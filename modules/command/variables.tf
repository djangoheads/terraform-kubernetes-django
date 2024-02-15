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
  type    = string
  default = "/home/app/config/override.yaml"
}

variable "secrets_mount_path" {
  type    = string
  default = "/home/app/config/.secrets.yaml"
}

variable "image_pull_policy" {
  type        = string
  default     = "Always"
  description = "Image pull policy"
}

variable "configmap_key" {
  type = string
  default = "override.yaml"
  description = "The key of the configmap to be used as the configuration for the application"
}

variable "configmap_path" {
  type = string
  default = "override.yaml"
  description = "The path where the configmap will be mounted"
}

variable "secret_key" {
  type = string
  default = ".secrets.yaml"
  description = "The key of the secret to be used as the configuration for the application"
}

variable "secret_path" {
  type = string
  default = ".secrets.yaml"
  description = "The path where the secret will be mounted"
}

variable "working_dir" {
  type = string
  default = "/home/app/libs"
  description = "The working directory for the container"
}

variable "config_revision" {
  type = string
  default = ""
  description = "The revision of the configmap to be used"
}

variable "secret_revision" {
  type = string
  default = ""
  description = "The revision of the secret to be used"
}

variable "limits" {
  description = "Resource limits (CPU and memory)"
  type        = map(string)
  default     = {}
}

variable "requests" {
  description = "Resource requests (CPU and memory)"
  type        = map(string)
  default     = {}
}

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

variable "init_image" {
  type        = string
  description = "init container image"
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

variable "container_port" {
  type        = number
  default     = 8000
  description = "container port to expose"
}

variable "service_port" {
  type        = number
  default     = 8000
  description = "service port to expose"
}

variable "service_target_port" {
  type        = number
  default     = 8000
  description = "targeting service to container port"
}

variable "env_vars" {
  description = "Environment variables for the storage module"
  type        = map(string)
  default     = {}
}
variable "init_command" {
  type        = list(string)
  default     = ["for i in {1..100}; do sleep 1; if django-admin migrate --check; then exit 0; fi; done; exit 1"]
  description = "Override command"
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

variable "readiness" {
  type = list(object({
    initial_delay_seconds = optional(number)
    period_seconds        = optional(number)
    timeout_seconds       = optional(number)
    failure_threshold     = optional(number)
    success_threshold     = optional(number)
    http_get              = optional(list(object({
      path = optional(string)
      port = optional(number)
    })))
  }))
  default = []
}

variable "liveness" {
  type = list(object({
    initial_delay_seconds = optional(number)
    period_seconds        = optional(number)
    timeout_seconds       = optional(number)
    failure_threshold     = optional(number)
    success_threshold     = optional(number)
    http_get              = optional(list(object({
      path = optional(string)
      port = optional(number)
    })))
  }))
  default = []
}

variable "enable_autoscaler" {
  description = "Boolean flag to enable/disable kubernetes horizontal pod autoscaler"
  type        = bool
  default     = false
}

variable "replica_count" {
  type        = number
  default     = 1
  description = "Number of replicas"
}

variable "cpu_target" {
  description = "Target CPU utilization percentage"
  type        = number
  default     = 110
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

variable "init_working_dir" {
  type = string
  default = "/home/app/libs"
  description = "The working directory for the init container"
}

variable "working_dir" {
  type = string
  default = "/home/app/libs"
  description = "The working directory for the container"
}

variable "service_annotation" {
  type = map(string)
  default = {}
  description = "Service annotations"
}

variable "max_surge" {
  type = number
  default = 1
  description = "The maximum number of pods that can be created above the desired number of pods"
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

variable "pdb_min_available" {
  description = "Minimum number of pods that must still be available after the eviction"
  type        = number
  default     = 1
}
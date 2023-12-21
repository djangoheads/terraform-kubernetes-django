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
variable "env_vars" {
  description = "Environment variables for the storage module"
  type        = map(string)
  default     = {}
}
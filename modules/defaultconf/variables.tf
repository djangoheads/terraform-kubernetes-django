variable "namespace" {
    type = string
}

variable "name" {
    type = string
}

# Configuration specific variables

variable "defaultconf" {
  type = object({
    settings = string
    secrets = string
  })
}

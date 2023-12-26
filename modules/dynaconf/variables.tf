variable "namespace" {
    type = string
}

variable "name" {
    type = string
}

# Configuration specific variables

variable "dynaconf" {
  type = object({
    settings = string
    secrets = string
  })
}

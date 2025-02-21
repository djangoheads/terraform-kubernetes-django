variable "namespace" {
    type = string
}

variable "name" {
    type = string
}

# Configuration specific variables

variable "defaultconf" {
  type = object({
    settings = map(string)
    secrets = map(string)
  })
}

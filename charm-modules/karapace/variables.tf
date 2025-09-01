# CC006 mandatory inputs
variable "app_name" {
  description = "Name of the Juju application"
  type        = string
}

variable "channel" {
  description = "Charm channel to deploy from"
  type        = string
}

variable "config" {
  description = "Application configuration"
  type        = map(string)
  default     = {}
}

variable "constraints" {
  description = "Juju constraints for the application"
  type        = string
  default     = "arch=amd64"
}

variable "model" {
  description = "Juju model to deploy to"
  type        = string
  default     = null
}

variable "revision" {
  description = "Charm revision to deploy"
  type        = number
  default     = null
}

variable "units" {
  description = "Number of units to deploy"
  type        = number
  default     = 1
}

# Additional inputs
variable "base" {
  description = "Application base"
  type        = string
  default     = "ubuntu@24.04"
}
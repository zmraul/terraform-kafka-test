variable "model_name" {
  description = "Juju model name to deploy to"
  type        = string
}

variable "deployment_mode" {
  description = "Kafka deployment mode: 'single' or 'split'"
  type        = string
  default     = "single"
  validation {
    condition     = contains(["single", "split"], var.deployment_mode)
    error_message = "Deployment mode must be either 'single' or 'split'."
  }
}

variable "broker_units" {
  description = "Number of broker units"
  type        = number
  default     = 3
}

variable "controller_units" {
  description = "Number of controller units (only used in split mode)"
  type        = number
  default     = 3
}

variable "channel" {
  description = "Kafka charm channel"
  type        = string
  default     = "4/edge"
}

variable "deploy_karapace" {
  description = "Whether to deploy Karapace schema registry"
  type        = bool
  default     = false
}

variable "karapace_channel" {
  description = "Karapace charm channel"
  type        = string
  default     = "latest/edge"
}

variable "base" {
  description = "Application base"
  type        = string
  default     = "ubuntu@24.04"
}
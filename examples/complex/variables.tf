variable "model_name" {
  description = "Name of the Juju model to deploy to"
  type        = string
  default     = "kafka"
}

variable "kafka_deployment_mode" {
  description = "Kafka deployment mode: 'single' or 'split'"
  type        = string
  default     = "split"

  validation {
    condition     = contains(["single", "split"], var.kafka_deployment_mode)
    error_message = "Deployment mode must be either 'single' or 'split'."
  }
}

variable "kafka_units" {
  description = "Number of Kafka units to deploy (single mode)"
  type        = number
  default     = 1
}

variable "kafka_broker_app_name" {
  description = "Name for the Kafka broker application (split mode)"
  type        = string
  default     = "kafka-broker"
}

variable "kafka_controller_app_name" {
  description = "Name for the Kafka controller application (split mode)"
  type        = string
  default     = "kafka-controller"
}

variable "kafka_broker_units" {
  description = "Number of Kafka broker units (split mode)"
  type        = number
  default     = 3
}

variable "kafka_controller_units" {
  description = "Number of Kafka controller units (split mode)"
  type        = number
  default     = 3
}

variable "enable_cos" {
  description = "Enable COS (Canonical Observability Stack) integration"
  type        = bool
  default     = false
}

variable "deploy_karapace" {
  description = "Deploy Karapace schema registry"
  type        = bool
  default     = true
}

variable "enable_rack_awareness" {
  description = "Enable rack awareness for Kafka brokers"
  type        = bool
  default     = false
}

variable "broker_rack" {
  description = "Rack ID for Kafka brokers"
  type        = string
  default     = "rack-1"
}

variable "kafka_machine_ids" {
  description = "Machine IDs where rack awareness should be deployed (user picks appropriate broker machines)"
  type        = list(string)
  default     = []
}

variable "tls_mode" {
  description = "TLS mode: '' (no TLS), 'internal' (deploy self-signed), or external app name"
  type        = string
  default     = ""
}
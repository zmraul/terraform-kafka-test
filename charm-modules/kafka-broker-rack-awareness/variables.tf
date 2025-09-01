variable "app_name" {
  description = "Name of the kafka-broker-rack-awareness application"
  type        = string
  default     = "kafka-broker-rack-awareness"
}

variable "model" {
  description = "Juju model to deploy to"
  type        = string
}

variable "channel" {
  description = "Charm channel to deploy"
  type        = string
  default     = "latest/edge"
}

variable "revision" {
  description = "Charm revision to deploy"
  type        = number
  default     = null
}

variable "base" {
  description = "Charm base"
  type        = string
  default     = "ubuntu@24.04"
}

variable "constraints" {
  description = "Juju constraints for the application"
  type        = string
  default     = "arch=amd64"
}

variable "config" {
  description = "Configuration for the kafka-broker-rack-awareness charm"
  type        = map(string)
  default     = {}
}

variable "broker_rack" {
  description = "The rack ID for the broker"
  type        = string
  default     = ""
}

variable "target_machines" {
  description = "List of machine IDs to deploy to (co-locate with Kafka)"
  type        = list(string)
  default     = []
}

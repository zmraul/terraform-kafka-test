variable "model_name" {
  description = "Name of the Juju model to deploy to"
  type        = string
  default     = "kafka"
}

variable "kafka_units" {
  description = "Number of Kafka units to deploy"
  type        = number
  default     = 3
}
variable "model_name" {
  description = "Name of the Juju model to deploy to"  
  type        = string
  default     = "kafka"
}

variable "kafka_deployment_mode" {
  description = "Kafka deployment mode: 'single' or 'split'"
  type        = string  
  default     = "single"
}

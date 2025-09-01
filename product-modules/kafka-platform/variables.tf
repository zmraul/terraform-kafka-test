# CC006 product configuration structure
variable "product_config" {
  description = "Configuration options for the Kafka platform"

  type = object({
    model_name = string

    network_binding = optional(object({
      external_client_access = optional(string, "")
    }), {})

    cos_endpoints = optional(map(string), {})
    tls_certificates_app = optional(string, "")
  })
}

variable "kafka" {
  description = "Configuration options for Kafka charm"

  type = object({
    # Common configuration
    channel         = optional(string, "4/edge")
    config          = optional(map(string), {})
    constraints     = optional(string, "arch=amd64")
    resources       = optional(map(string), {})
    revision        = optional(number)
    base            = optional(string, "ubuntu@24.04")
    deployment_mode = optional(string, "single")

    # Single mode: one application name and units
    app_name = optional(string, "kafka")
    units    = optional(number, 1)

    # Split mode: separate broker and controller application names and units
    broker_app_name     = optional(string, "kafka-broker")
    controller_app_name = optional(string, "kafka-controller")
    broker_units        = optional(number, 3)
    controller_units    = optional(number, 3)
  })

  default = {}

  validation {
    condition     = contains(["single", "split"], var.kafka.deployment_mode)
    error_message = "Kafka deployment mode must be either 'single' or 'split'."
  }
}

variable "karapace" {
  description = "Configuration options for Karapace charm"

  type = object({
    app_name    = optional(string, "karapace")
    channel     = optional(string, "latest/edge")
    config      = optional(map(string), {})
    constraints = optional(string, "arch=amd64")
    resources   = optional(map(string), {})
    revision    = optional(number)
    base        = optional(string, "ubuntu@24.04")
    units       = optional(number, 1)
  })

  default = {}
}

variable "kafka_broker_rack_awareness" {
  description = "Configuration options for Kafka Broker Rack Awareness charm"

  type = object({
    app_name        = optional(string, "kafka-broker-rack-awareness")
    channel         = optional(string, "latest/edge")
    config          = optional(map(string), {})
    constraints     = optional(string, "arch=amd64")
    revision        = optional(number)
    base            = optional(string, "ubuntu@24.04")
    broker_rack     = optional(string, "")
    target_machines = optional(list(string), [])
  })

  default = {}
}

variable "grafana_agent" {
  description = "Configuration options for Grafana Agent charm"

  type = object({
    app_name    = optional(string, "grafana-agent")
    channel     = optional(string, "2/edge")
    config      = optional(map(string), {})
    constraints = optional(string)
    resources   = optional(map(string), {})
    revision    = optional(number)
    base        = optional(string, "ubuntu@24.04")
    units       = optional(number)
  })

  default = {}
}

variable "self-signed-certificates" {
  description = "Configuration for the self-signed-certificates app"
  type = object({
    channel     = optional(string, "latest/stable")
    revision    = optional(string, null)
    base        = optional(string, "ubuntu@22.04")
    constraints = optional(string, "arch=amd64")
    machines    = optional(list(string), [])
    config      = optional(map(string), { "ca-common-name" : "CA" })
  })
  default = {}

  validation {
    condition     = length(var.self-signed-certificates.machines) <= 1
    error_message = "Machine count should be at most 1"
  }
}

# High-level product controls
variable "deploy_karapace" {
  description = "Whether to deploy Karapace schema registry"
  type        = bool
  default     = false
}


variable "enable_rack_awareness" {
  description = "Enable rack awareness for Kafka brokers"
  type        = bool
  default     = false
}

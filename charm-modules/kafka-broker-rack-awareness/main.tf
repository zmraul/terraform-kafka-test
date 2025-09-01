# Deploy kafka-broker-rack-awareness as a co-located charm
resource "juju_application" "kafka_broker_rack_awareness" {
  model = var.model
  name  = var.app_name

  charm {
    name     = "kafka-broker-rack-awareness"
    channel  = var.channel
    revision = var.revision
    base     = var.base
  }

  constraints = var.constraints
  
  # Merge broker-rack configuration with any additional config
  config = merge(
    var.config,
    var.broker_rack != "" ? {
      "broker-rack" = var.broker_rack
    } : {}
  )

  machines = var.target_machines
}
output "deployment_mode" {
  description = "Kafka deployment mode used"
  value       = var.deployment_mode
}

output "kafka_application_name" {
  description = "Name of the main Kafka application"
  value = var.deployment_mode == "single" ? (
    length(juju_application.kafka_single) > 0 ? juju_application.kafka_single[0].name : null
  ) : (
    length(juju_application.kafka_broker) > 0 ? juju_application.kafka_broker[0].name : null
  )
}

output "controller_application_name" {
  description = "Name of the controller application (split mode only)"
  value = var.deployment_mode == "split" ? (
    length(juju_application.kafka_controller) > 0 ? juju_application.kafka_controller[0].name : null
  ) : null
}

output "broker_application_name" {
  description = "Name of the broker application (split mode only)"
  value = var.deployment_mode == "split" ? (
    length(juju_application.kafka_broker) > 0 ? juju_application.kafka_broker[0].name : null
  ) : null
}

output "karapace_deployed" {
  description = "Whether Karapace schema registry is deployed"
  value       = var.deploy_karapace
}

output "karapace_application_name" {
  description = "Name of the Karapace application (if deployed)"
  value = var.deploy_karapace ? (
    length(juju_application.karapace) > 0 ? juju_application.karapace[0].name : null
  ) : null
}
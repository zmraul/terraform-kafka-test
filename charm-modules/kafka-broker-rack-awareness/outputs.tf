# CC006 mandatory outputs
output "app_name" {
  description = "Name of the kafka-broker-rack-awareness application"
  value       = juju_application.kafka_broker_rack_awareness.name
}

output "endpoints" {
  description = "Service access endpoints"
  value = {
    # This charm doesn't expose service endpoints
  }
}

output "provides_endpoints" {
  description = "Relation endpoints this charm provides"
  value = [
    # This is a co-located charm that operates via machine placement
  ]
}

output "offers" {
  description = "offers created by this charm"
  value = {
    # This charm doesn't create offers
  }
}

# Single mode: Combined broker+controller
resource "juju_application" "kafka_single" {
  count = var.deployment_mode == "single" ? 1 : 0
  model = var.model_name
  
  charm {
    name    = "kafka"
    channel = var.channel
    base    = var.base
  }
  
  units = var.broker_units
  config = {
    roles = "broker,controller"
  }
}

# Split mode: Separate controller
resource "juju_application" "kafka_controller" {
  count = var.deployment_mode == "split" ? 1 : 0
  model = var.model_name
  name  = "controller"
  
  charm {
    name    = "kafka"
    channel = var.channel
    base    = var.base
  }
  
  units = var.controller_units
  config = {
    roles = "controller"
  }
}

# Split mode: Separate broker
resource "juju_application" "kafka_broker" {
  count = var.deployment_mode == "split" ? 1 : 0
  model = var.model_name
  name  = "broker"
  
  charm {
    name    = "kafka"
    channel = var.channel
    base    = var.base
  }
  
  units = var.broker_units
  config = {
    roles = "broker"
  }
}

# Split mode: Integration between broker and controller
resource "juju_integration" "broker_controller" {
  count = var.deployment_mode == "split" ? 1 : 0
  model = var.model_name
  
  application {
    name     = juju_application.kafka_broker[0].name
    endpoint = "peer-cluster-orchestrator"
  }
  
  application {
    name     = juju_application.kafka_controller[0].name
    endpoint = "peer-cluster"
  }
}

# Optional Karapace schema registry
resource "juju_application" "karapace" {
  count = var.deploy_karapace ? 1 : 0
  model = var.model_name
  name  = "karapace"
  
  charm {
    name    = "karapace"
    channel = var.karapace_channel
    base    = var.base
  }
  
  units = 1
}

# Integration between Karapace and Kafka
resource "juju_integration" "karapace_kafka" {
  count = var.deploy_karapace ? 1 : 0
  model = var.model_name
  
  application {
    name = juju_application.karapace[0].name
  }
  
  application {
    name = var.deployment_mode == "single" ? (
      juju_application.kafka_single[0].name
    ) : (
      juju_application.kafka_broker[0].name
    )
  }
}
terraform {
  required_providers {
    juju = {
      source  = "juju/juju"
      version = "~> 0.10.1"
    }
  }
}

provider "juju" {}

# Reference to existing model
data "juju_model" "target" {
  name = var.model_name
}

# Deploy Kafka using module
module "kafka" {
  source = "./modules/kafka"
  
  model_name      = data.juju_model.target.name
  deployment_mode = var.kafka_deployment_mode
}
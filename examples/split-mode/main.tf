terraform {
  required_providers {
    juju = {
      source  = "juju/juju"
      version = ">= 0.20.0"
    }
  }
}

provider "juju" {}

data "juju_model" "target" {
  name = var.model_name
}

module "kafka_platform" {
  source = "../../product-modules/kafka-platform"

  product_config = {
    model_name = data.juju_model.target.name
    network_binding = {
      external_client_access = ""
    }
    cos_endpoints = {}
  }

  kafka = {
    deployment_mode = "split"
    units          = var.kafka_broker_units
  }
}

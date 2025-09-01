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
    cos_endpoints = var.enable_cos ? {
      grafana = "admin/cos-lite.grafana"
    } : {}
    tls_certificates_app = var.tls_mode
  }

  kafka = var.kafka_deployment_mode == "single" ? {
    deployment_mode = var.kafka_deployment_mode
    broker_units    = var.kafka_broker_units
  } : {
    deployment_mode     = var.kafka_deployment_mode
    broker_app_name     = var.kafka_broker_app_name
    controller_app_name = var.kafka_controller_app_name
    broker_units        = var.kafka_broker_units
    controller_units    = var.kafka_controller_units
  }

  deploy_karapace       = var.deploy_karapace
  enable_rack_awareness = var.enable_rack_awareness

  kafka_broker_rack_awareness = {
    broker_rack     = var.broker_rack
    target_machines = var.kafka_machine_ids
  }
}

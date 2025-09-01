# Deploy Kafka using charm module
module "kafka" {
  source = "../../charm-modules/kafka"

  app_name             = var.kafka.app_name
  model                = var.product_config.model_name
  channel              = var.kafka.channel
  deployment_mode      = var.kafka.deployment_mode
  units                = var.kafka.units
  config               = var.kafka.config
  constraints          = var.kafka.constraints
  revision             = var.kafka.revision
  base                 = var.kafka.base
  broker_units         = var.kafka.broker_units
  controller_units     = var.kafka.controller_units
  broker_app_name      = var.kafka.broker_app_name
  controller_app_name  = var.kafka.controller_app_name
}

# Deploy Karapace using charm module (optional)
module "karapace" {
  count  = var.deploy_karapace ? 1 : 0
  source = "../../charm-modules/karapace"

  app_name    = var.karapace.app_name
  model       = var.product_config.model_name
  channel     = var.karapace.channel
  units       = var.karapace.units
  config      = var.karapace.config
  constraints = var.karapace.constraints
  revision    = var.karapace.revision
  base        = var.karapace.base
}

# Deploy Kafka Broker Rack Awareness
module "kafka_broker_rack_awareness" {
  count  = var.enable_rack_awareness ? 1 : 0
  source = "../../charm-modules/kafka-broker-rack-awareness"

  app_name        = var.kafka_broker_rack_awareness.app_name
  model           = var.product_config.model_name
  channel         = var.kafka_broker_rack_awareness.channel
  revision        = var.kafka_broker_rack_awareness.revision
  base            = var.kafka_broker_rack_awareness.base
  constraints     = var.kafka_broker_rack_awareness.constraints
  config          = var.kafka_broker_rack_awareness.config
  broker_rack     = var.kafka_broker_rack_awareness.broker_rack
  target_machines = var.kafka_broker_rack_awareness.target_machines
}

# Deploy Grafana Agent for observability
resource "juju_application" "grafana_agent" {
  count = length(var.product_config.cos_endpoints) > 0 ? 1 : 0
  model = var.product_config.model_name
  name  = var.grafana_agent.app_name

  charm {
    name     = "grafana-agent"
    channel  = var.grafana_agent.channel
    revision = var.grafana_agent.revision
    base     = var.grafana_agent.base
  }

  units       = var.grafana_agent.units
  constraints = var.grafana_agent.constraints
  config      = var.grafana_agent.config
}

# Deploy self-signed-certificates for internal TLS mode
resource "juju_application" "self_signed_certificates" {
  count = var.product_config.tls_certificates_app == "internal" ? 1 : 0
  model = var.product_config.model_name
  name  = "self-signed-certificates"

  charm {
    name     = "self-signed-certificates"
    channel  = var.self-signed-certificates.channel
    revision = var.self-signed-certificates.revision
    base     = var.self-signed-certificates.base
  }

  constraints = var.self-signed-certificates.constraints
  config      = var.self-signed-certificates.config
}

# Integration between Kafka and Karapace
resource "juju_integration" "kafka_karapace" {
  count = var.deploy_karapace ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name = module.karapace[0].app_name
  }
  
  application {
    name = var.kafka.deployment_mode == "split" ? module.kafka.broker_app_name : module.kafka.app_name
  }
}

# COS Integration: Kafka -> Grafana Agent
resource "juju_integration" "kafka_cos" {
  count = length(var.product_config.cos_endpoints) > 0 ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = var.kafka.deployment_mode == "split" ? module.kafka.broker_app_name : module.kafka.app_name
    endpoint = "cos-agent"
  }
  
  application {
    name     = juju_application.grafana_agent[0].name
    endpoint = "cos-agent"
  }
}

# COS Integration: Kafka Controller (split mode only) -> Grafana Agent
resource "juju_integration" "kafka_controller_cos" {
  count = var.kafka.deployment_mode == "split" && length(var.product_config.cos_endpoints) > 0 ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = module.kafka.controller_app_name
    endpoint = "cos-agent"
  }
  
  application {
    name     = juju_application.grafana_agent[0].name
    endpoint = "cos-agent"
  }
}

# COS Integration: Karapace -> Grafana Agent
resource "juju_integration" "karapace_cos" {
  count = var.deploy_karapace && length(var.product_config.cos_endpoints) > 0 ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = module.karapace[0].app_name
    endpoint = "cos-agent"
  }
  
  application {
    name     = juju_application.grafana_agent[0].name
    endpoint = "cos-agent"
  }
}

# TLS Integration: Kafka -> certificates (Single mode)
resource "juju_integration" "kafka_tls_single" {
  count = var.product_config.tls_certificates_app != "" && var.kafka.deployment_mode == "single" ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = module.kafka.app_name
    endpoint = "certificates"
  }
  
  application {
    name     = var.product_config.tls_certificates_app == "internal" ? juju_application.self_signed_certificates[0].name : var.product_config.tls_certificates_app
    endpoint = "certificates"
  }
}

# TLS Integration: Kafka Broker -> certificates (Split mode)
resource "juju_integration" "kafka_broker_tls" {
  count = var.product_config.tls_certificates_app != "" && var.kafka.deployment_mode == "split" ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = module.kafka.broker_app_name
    endpoint = "certificates"
  }
  
  application {
    name     = var.product_config.tls_certificates_app == "internal" ? juju_application.self_signed_certificates[0].name : var.product_config.tls_certificates_app
    endpoint = "certificates"
  }
}

# TLS Integration: Kafka Controller -> certificates (Split mode)
resource "juju_integration" "kafka_controller_tls" {
  count = var.product_config.tls_certificates_app != "" && var.kafka.deployment_mode == "split" ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = module.kafka.controller_app_name
    endpoint = "certificates"
  }
  
  application {
    name     = var.product_config.tls_certificates_app == "internal" ? juju_application.self_signed_certificates[0].name : var.product_config.tls_certificates_app
    endpoint = "certificates"
  }
}

# TLS Integration: Karapace -> certificates
resource "juju_integration" "karapace_tls" {
  count = var.product_config.tls_certificates_app != "" && var.deploy_karapace ? 1 : 0
  model = var.product_config.model_name
  
  application {
    name     = module.karapace[0].app_name
    endpoint = "certificates"
  }
  
  application {
    name     = var.product_config.tls_certificates_app == "internal" ? juju_application.self_signed_certificates[0].name : var.product_config.tls_certificates_app
    endpoint = "certificates"
  }
}

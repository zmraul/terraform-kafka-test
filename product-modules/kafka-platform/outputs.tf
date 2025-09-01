# CC006 mandatory outputs for product modules
output "provides" {
  description = "offers, endpoints, and optional credentials exposed per application."

  value = merge(
    {
      kafka = {
        sass = module.kafka.offers
        endpoints   = module.kafka.endpoints
        credentials = {}
      }
    },
    var.deploy_karapace ? {
      karapace = {
        sass = module.karapace[0].offers
        endpoints   = module.karapace[0].endpoints
        credentials = {}
      }
    } : {},
    length(var.product_config.cos_endpoints) > 0 ? {
      grafana-agent = {
        sass        = {}
        endpoints   = {}
        credentials = {}
      }
    } : {}
  )
}

output "model_info" {
  description = "Name, controller, and cloud of the model that hosts the product."

  value = {
    model_name = var.product_config.model_name
    controller = "unknown"  # This would be set by deployment context
    cloud      = "unknown"  # This would be set by deployment context
  }
}

output "metadata" {
  description = "Product version and the timestamp of this deployment."

  value = {
    version     = "1.0.0"  # This should be managed by versioning
    deployed_at = timestamp()
    updated_at  = timestamp()
  }
}
model_name = "k"

# Kafka single mode configuration
kafka_deployment_mode = "single"
kafka_broker_units           = 1

# Kafka split mode configuration
# kafka_deployment_mode     = "split"
# kafka_broker_app_name     = "broker"
# kafka_controller_app_name = "controller"
# kafka_controller_units    = 1

# Enable COS integration
enable_cos = false

# Deploy Karapace schema registry
deploy_karapace = false

# TLS Configuration - 3 modes supported:
# tls_mode = ""                       # No TLS (default)
# tls_mode = "internal"               # Deploy self-signed certificates  
# tls_mode = "certificates-operator"  # Use external certificates provider
tls_mode = ""

# Enable rack awareness
enable_rack_awareness = false
broker_rack = "zone-1"
# Machine IDs where rack awareness should be deployed
kafka_machine_ids = ["7"]


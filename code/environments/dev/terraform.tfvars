# terraform plan -var-file="configs\dev.tfvars"
gcp_key_file_path = "../../secret_keys/gcp-terraform-learning-433318-856001c6d6fb.json"
gcp_project_id    = "gcp-terraform-learning-433318"
gcp_region        = "us-west1"

# Bucket
bucket_name                    = "marketplace_bucket_app"
bucket_object_source_directory = "../../setup_files"

# Network
vpc_name = "marketplace-vpc-dev"
subnetwork_configs = {
  private_network = {
    name          = "marketplace-private-dev"
    ip_cidr_range = "10.0.10.0/24"
    region        = "us-west1"
  }
}

firewall_rule_mapping = {
  allow_http = {
    name          = "allow-alb-http"
    protocol      = "tcp"
    ports         = ["80"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["web-servers-dev"]
  }

  allow_ssh = {
    name          = "allow-external-ssh"
    protocol      = "tcp"
    ports         = ["22"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["web-servers-dev"]
  }
}

# Instance Template
machine_type  = "f1-micro"
template_name = "vm-server-dev"
tags          = "web-servers-dev"

# Instance Group
instance_group_name   = "webserver-mig-dev"
instance_base_name    = "server-dev"
instance_group_region = "us-west1"
target_size           = 2

# Database
database_name            = "marketplace_database"
database_instance_name   = "marketplace-db-dev"
database_instance_region = "us-west1"

# Load Balancer
load_balancer_name     = "http-lb-dev"
http_health_check_name = "http-health-check"
http_health_check_port = 80
backend_service_name   = "app-backend-service"
network_ip_cidr_range  = "10.0.30.0/24"

module "bucket" {
  source                         = "./modules/bucket"
  bucket_name                    = "app_bucket_demo"
  bucket_location                = var.gcp_region
  bucket_object_source_directory = "./setup_files"
}

module "network" {
  source     = "./modules/network"
  vpc_name   = "marketplace-vpc"
  project_id = var.gcp_project_id
  subnetwork_configs = {
    private_network = {
      name          = "marketplace-private"
      ip_cidr_range = "10.0.10.0/24"
      region        = "us-west1"
    }
  }

  firewall_rule_mapping = {
    allow_http = {
      name          = "allow-alb-http"
      protocol      = "tcp"
      ports         = ["80"]
      source_tags   = ["http-load-balancer"]
      source_ranges = []
      target_tags   = ["web-servers"]
    }

    allow_ssh = {
      name          = "allow-external-ssh"
      protocol      = "tcp"
      ports         = ["22"]
      source_tags   = []
      source_ranges = ["0.0.0.0/0"]
      target_tags   = ["web-servers"]
    }
  }
}

module "instance_template" {
  source             = "./modules/instance_template"
  project_id         = var.gcp_project_id
  vpc_id             = module.network.vpc_id
  subnetwork_id      = module.network.subnetworks_id
  startup_script_url = module.bucket.setup_sh_url
  machine_type       = var.machine_type
  template_name      = var.template_name
  setup_bucket = module.bucket.bucket_name
}

module "instance_group" {
  source                             = "./modules/instance_group"
  instance_group_name                = "webserver-mig"
  instance_base_name                 = "server"
  instance_group_network_id          = module.network.vpc_id
  template_instance_self_link_unique = module.instance_template.instance_template_self_link_unique
  instance_group_region              = var.gcp_region
  target_size                        = 2
}

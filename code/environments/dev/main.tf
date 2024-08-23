module "utils" {
  source = "../../modules/utils"
  region = var.gcp_region
}

module "bucket" {
  source                         = "../../modules/bucket"
  bucket_name                    = var.bucket_name
  bucket_location                = var.gcp_region
  bucket_object_source_directory = var.bucket_object_source_directory
}

module "network" {
  source                = "../../modules/network"
  vpc_name              = var.vpc_name
  project_id            = var.gcp_project_id
  subnetwork_configs    = var.subnetwork_configs
  firewall_rule_mapping = var.firewall_rule_mapping
}

module "iam" {
  source      = "../../modules/iam"
  project_id  = var.gcp_project_id
  account_id  = "${var.template_name}-service-account"
  bucket_name = module.bucket.bucket_name
}

module "instance_template" {
  source                = "../../modules/instance_template"
  project_id            = var.gcp_project_id
  vpc_id                = module.network.vpc_id
  subnetwork_id         = module.network.subnetworks_id
  startup_script_url    = module.bucket.setup_sh_url
  machine_type          = var.machine_type
  template_name         = var.template_name
  setup_bucket          = module.bucket.bucket_name
  tags                  = var.tags
  service_account_email = module.iam.webserver_service_account.email
}

module "database" {
  source                       = "../../modules/database"
  database_name                = var.database_name
  database_instance_name       = var.database_instance_name
  database_instance_region     = var.database_instance_region
  database_instance_network_id = module.network.vpc_id
  server_service_account_email = module.iam.webserver_service_account.email
}

module "instance_group" {
  source                             = "../../modules/instance_group"
  instance_group_name                = var.instance_group_name
  instance_base_name                 = var.instance_base_name
  instance_group_network_id          = module.network.vpc_id
  template_instance_self_link_unique = module.instance_template.instance_template_self_link_unique
  instance_group_region              = var.instance_group_region
  target_size                        = var.target_size
  distribution_policy_zones          = module.utils.available_zones
  depends_on                         = [module.database] # The startup-script-url needs to wait for the creation of database secrets
}

module "load_balancer" {
  source                             = "../../modules/load_balancer"
  load_balancer_name                 = var.load_balancer_name
  http_health_check_name             = var.http_health_check_name
  http_health_check_port             = var.http_health_check_port
  webserver_instance_group_self_link = module.instance_group.webserver_instance_group_self_link
  backend_service_name               = var.backend_service_name
  network_region                     = var.gcp_region
  network_id                         = module.network.vpc_id
  network_ip_cidr_range              = var.network_ip_cidr_range
}

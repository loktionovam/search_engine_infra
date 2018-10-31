provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

data "terraform_remote_state" "state" {
  backend = "gcs"

  config {
    bucket = "search-engine-tf-state-prod-20181031002"
  }
}

module "docker_host" {
  source                 = "../modules/docker_host"
  project                = "${var.project}"
  public_key_path        = "${var.public_key_path}"
  private_key_path       = "${var.private_key_path}"
  zone                   = "${var.zone}"
  docker_host_disk_image = "${var.docker_host_disk_image}"
  count                  = "${var.count}"
  size                   = "${var.size}"
  app_provision_enabled  = "${var.app_provision_enabled}"
  app_name               = "${var.app_name}"
  environment            = "${var.environment}"
}

module "vpc" {
  source        = "../modules/vpc"
  source_ranges = "${var.source_ranges}"
}

module "search_engine_vpc" {
  source = "../modules/search_engine_vpc"
  source_ranges = "[0.0.0.0/0]"
}

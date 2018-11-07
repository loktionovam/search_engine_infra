provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

data "terraform_remote_state" "state" {
  backend = "gcs"

  config {
    bucket = "kubernetes-tf-state-bucket-20181022001"
  }
}

module "gke" {
  source                   = "../modules/gke"
  project                  = "${var.project}"
  region                   = "${var.region}"
  zone                     = "${var.zone}"
  cluster_name             = "${var.cluster_name}"
  defaultpool_machine_type = "${var.defaultpool_machine_type}"
  bigpool_machine_type     = "${var.bigpool_machine_type}"

  defaultpool_machine_size = "${var.defaultpool_machine_size}"
  bigpool_machine_size     = "${var.bigpool_machine_size}"

  defaultpool_nodes_count = "${var.defaultpool_nodes_count}"
  bigpool_nodes_count     = "${var.bigpool_nodes_count}"

  min_master_version = "${var.min_master_version}"
}

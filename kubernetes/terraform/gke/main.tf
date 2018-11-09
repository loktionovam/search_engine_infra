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

resource "null_resource" "bootstrap_gke" {
  depends_on = ["module.gke"]

  triggers {
    kubernetes_endpoint = "${module.gke.kubernetes_endpoint}"
  }

  provisioner "local-exec" {
    command = "../../bootstrap.sh ${var.cluster_name} ${var.zone} ${var.project} ${google_compute_address.search_engine_ip.address}"
  }
}

resource "google_compute_address" "search_engine_ip" {
  name = "search-engine"
}

resource "google_dns_managed_zone" "search_engine" {
  name        = "search-engine-zone"
  dns_name    = "${var.search_engine_dns_zone}"
  description = "Search engine DNS zone"
}

resource "google_dns_record_set" "wildcard_search_engine" {
  name         = "*.${google_dns_managed_zone.search_engine.dns_name}"
  managed_zone = "${google_dns_managed_zone.search_engine.name}"
  type         = "A"
  ttl          = 300

  rrdatas = ["${google_compute_address.search_engine_ip.address}"]
}

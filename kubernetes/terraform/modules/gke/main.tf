provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_container_cluster" "kubernetes" {
  name               = "${var.cluster_name}"
  zone               = "${var.zone}"
  min_master_version = "${var.min_master_version}"
  enable_legacy_abac = true

  addons_config {
    kubernetes_dashboard = {
      disabled = true
    }
  }

  node_pool {
    name       = "defaultpool"
    node_count = "${var.defaultpool_nodes_count}"

    node_config {
      machine_type = "${var.defaultpool_machine_type}"
      disk_size_gb = "${var.defaultpool_machine_size}"
    }
  }

  node_pool {
    name       = "bigpool"
    node_count = "${var.bigpool_nodes_count}"

    node_config {
      machine_type = "${var.bigpool_machine_type}"
      disk_size_gb = "${var.bigpool_machine_size}"

      labels {
        elastichost = "true"
      }
    }
  }
}

resource "google_compute_firewall" "firewall_kubernetes" {
  name    = "allow-kubernetes"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["30000-32767"]
  }

  source_ranges = ["0.0.0.0/0"]
}

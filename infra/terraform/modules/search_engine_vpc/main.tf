resource "google_compute_firewall" "firewall_search_engine_ui" {
  name    = "allow-search-engine-ui-${terraform.workspace}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8000"]
  }

  source_ranges = "${var.source_ranges}"
  target_tags   = ["docker-host"]
}

resource "google_compute_firewall" "firewall_search_engine_grafana" {
  name    = "allow-search-engine-grafana-${terraform.workspace}"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["3000"]
  }

  source_ranges = "${var.source_ranges}"
  target_tags   = ["docker-host"]
}

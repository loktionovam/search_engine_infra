resource "google_compute_firewall" "firewall_ssh" {
  name        = "${terraform.workspace}-allow-ssh"
  network     = "default"
  description = "Allow SSH from anywhere"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = "${var.source_ranges}"
}

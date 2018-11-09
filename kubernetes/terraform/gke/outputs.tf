output "kubernetes_endpoint" {
  value = "${module.gke.kubernetes_endpoint}"
}

output "search_engine_ip" {
  value = "${google_compute_address.search_engine_ip.address}"
}

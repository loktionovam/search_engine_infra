terraform {
  backend "gcs" {
    bucket = "kubernetes-tf-state-bucket-20181022001"
    prefix = "gke/terraform/state"
  }
}

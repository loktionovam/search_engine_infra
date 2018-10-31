terraform {
  backend "gcs" {
    bucket = "search-engine-tf-state-prod-20181031001"
    prefix = "terraform/state"
  }
}

terraform {
  backend "gcs" {
    bucket = "search-engine-tf-state-prod-20181031002"
    prefix = "terraform/state"
  }
}

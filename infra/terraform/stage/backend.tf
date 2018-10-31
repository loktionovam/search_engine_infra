terraform {
  backend "gcs" {
    bucket = "search-engine-tf-state-stage-20181031001"
    prefix = "terraform/state"
  }
}

terraform {
  backend "gcs" {
    bucket = "search-engine-tf-state-stage-20181031002"
    prefix = "terraform/state"
  }
}

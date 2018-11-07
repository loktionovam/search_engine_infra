variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable zone {
  description = "Zone"
  default     = "europe-west1-b"
}

variable cluster_name {
  description = "Cluster name"
  default     = "cluster-1"
}

variable defaultpool_machine_type {
  description = "Machine type for default pool"
  default     = "g1-small"
}

variable bigpool_machine_type {
  description = "Machine type for big pool"
  default     = "n1-standard-2"
}

variable bigpool_machine_size {
  description = "Machine boot disk size for bigpool pool"
  default     = 20
}

variable defaultpool_machine_size {
  description = "Machine boot disk size for default pool"
  default     = 20
}

variable "bigpool_nodes_count" {
  description = "Cluster nodes count in the big pool"
  default     = 1
}

variable "defaultpool_nodes_count" {
  description = "Cluster nodes count in the default pool"
  default     = 2
}

variable "min_master_version" {
  description = "The minimum version of the master"
  default     = "1.9.7-gke.6"
}

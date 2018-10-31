provider "google" {
  version = "1.4.0"
  project = "${var.project}"
  region  = "${var.region}"
}

resource "google_compute_instance" "docker_host" {
  name         = "${format("docker-host-${terraform.workspace}-%03d", count.index + 1)}"
  machine_type = "${var.machine_type}"
  zone         = "${var.zone}"

  tags  = ["docker-host", "docker-host-${terraform.workspace}"]
  count = "${var.count}"

  metadata {
    ssh-keys = "docker-user:${file(var.public_key_path)}"
  }

  boot_disk {
    initialize_params {
      image = "${var.docker_host_disk_image}"
      size  = "${var.size}"
    }
  }

  network_interface {
    network = "default"

    access_config = {
      nat_ip = "${google_compute_address.app_ip.address}"
    }
  }

  connection {
    type        = "ssh"
    user        = "docker-user"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }
}

resource "null_resource" "app" {
  count = "${var.app_provision_enabled ? 1 : 0}"

  connection {
    type = "ssh"

    host        = "${google_compute_address.app_ip.address}"
    user        = "docker-user"
    agent       = false
    private_key = "${file(var.private_key_path)}"
  }

  provisioner "remote-exec" {
    inline = [
      "while fuser /var/lib/dpkg/lock ; do echo 'dpkg locked, waiting...'; sleep 3;done",
    ]
  }

  provisioner "local-exec" {
    command     = "ansible-playbook playbooks/gce_dynamic_inventory_setup.yml --extra-vars='env=${var.environment}'"
    working_dir = "../../ansible"

    environment {
      ANSIBLE_CONFIG = "./ansible.cfg"
    }
  }

  provisioner "local-exec" {
    command     = "environments/${var.environment}/gce.py --refresh-cache >/dev/null 2>&1"
    working_dir = "../../ansible"
  }

  provisioner "local-exec" {
    command     = "ansible-playbook -l ${google_compute_address.app_ip.address} --private-key ${var.private_key_path} playbooks/${var.app_name}.yml"
    working_dir = "../../ansible"

    environment {
      ANSIBLE_CONFIG = "./ansible.cfg"
    }
  }
}

resource "google_compute_address" "app_ip" {
  name = "app-ip-${terraform.workspace}"
}

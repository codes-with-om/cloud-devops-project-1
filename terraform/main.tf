terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}

resource "google_compute_network" "main" {
  name                    = "cloud-project-1-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "main" {
  name          = "cloud-project-1-subnet"
  ip_cidr_range = "10.0.0.0/24"
  region        = var.region
  network       = google_compute_network.main.id
}

resource "google_compute_instance" "app" {
  name         = "cloud-project-1-vm"
  machine_type = "e2-micro"
  zone         = "asia-south1-b"

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2404-lts-amd64"
      size  = 10
      type  = "pd-balanced"
    }
  }

  network_interface {
    network    = google_compute_network.main.id
    subnetwork = google_compute_subnetwork.main.id

    access_config {}
  }
}

resource "google_compute_firewall" "ssh" {
  name    = "cloud-project-1-allow-ssh"
  network = google_compute_network.main.id

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
}
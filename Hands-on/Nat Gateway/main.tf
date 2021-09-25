resource "google_compute_instance" "default" {
  name         = "test"
  machine_type = "e2-micro"
  zone         = var.gcp_zone

  tags = [
    "${var.vpc_name}-firewall-ssh",
   "${var.vpc_name}-firewall-icmp" 
  ]

  boot_disk {
    initialize_params {
      image = var.os[0].ubuntu-1604-lts
    }
  }


  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

    access_config {
      // Ephemeral public IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"


}
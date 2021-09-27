resource "google_compute_instance" "private-instance" {
  name         = "private-instance"
  machine_type = "e2-micro"
  zone         = var.gcp_zone

  tags = [
    "${var.vpc_name}-allow-ssh",
    "${var.vpc_name}-instance-without-external-ip"
  ]

  boot_disk {
    initialize_params {
      image = var.os[0].ubuntu-1604-lts
    }
  }


  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

    #to create a VM in GCP via terraform without External IP, you can just comment the access_config
    #access_config {
      #// Ephemeral public IP
    #}
  }

}


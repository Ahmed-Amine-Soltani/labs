resource "google_compute_instance" "nat-gateway-instance" {
  name           = "nat-gateway-instance"
  machine_type   = "e2-micro"
  can_ip_forward = true
  zone           = var.gcp_zone

  tags = [
    "${var.vpc_name}-allow-ssh",
    "${var.vpc_name}-allow-internal-traffic"
  ]

  boot_disk {
    initialize_params {
      image = var.os[0].ubuntu-1604-lts
    }
  }


  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

    access_config {
      // Ephemeral public IP
    }
  }


  metadata_startup_script = file("./scripts/iptable-ip_forward.sh")

  #  metadata_startup_script = <<SCRIPT
  #sudo sysctl -w net.ipv4.ip_forward=1
  #sudo iptables -t nat -A POSTROUTING -o $(paste <(ip -o -br link) <(ip -o -br addr) | awk '$2=="UP" {print $1}') -j MASQUERADE
  #SCRIPT


}

resource "google_compute_instance" "private-instance" {
  name         = "private-instance"
  machine_type = "e2-micro"
  zone         = var.gcp_zone

  tags = [
    "${var.vpc_name}-allow-ssh",
    "${var.vpc_name}-allow-internal-traffic",
    "instance-without-external-ip"
  ]

  boot_disk {
    initialize_params {
      image = var.os[0].ubuntu-1604-lts
    }
  }


  network_interface {
    network    = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.vpc_subnet.name

    # to create a VM in GCP via terraform without External IP, you can just comment the access_config
    #access_config {
      #// Ephemeral public IP
    #}
  }

}


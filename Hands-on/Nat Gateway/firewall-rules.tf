resource "google_compute_firewall" "ssh" {
  name          = "${var.vpc_name}-firewall-ssh"
  description   = "description"
  network       = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.vpc_name}-firewall-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }


}


resource "google_compute_firewall" "icmp" {
  name    = "${var.vpc_name}-firewall-icmp"
  network = google_compute_network.vpc_network.id

  allow {
    protocol = "icmp"
  }

  target_tags   = ["${var.vpc_name}-firewall-icmp"]
  source_ranges = ["0.0.0.0/0"]
}
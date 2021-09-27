resource "google_compute_firewall" "allow-ssh" {
  name          = "${var.vpc_name}-allow-ssh"
  description   = "description"
  network       = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  priority      = 1000
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.vpc_name}-allow-ssh"]

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

}
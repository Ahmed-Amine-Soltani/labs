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

resource "google_compute_firewall" "allow-internal-traffic" {
  name    = "${var.vpc_name}-allow-internal-traffic"
  network = google_compute_network.vpc_network.id
  direction     = "INGRESS"
  priority      = 1000

  allow {
    protocol = "all"
  }

  target_tags   = ["${var.vpc_name}-allow-internal-traffic"]
  source_ranges = [var.subnet_ip_cider_range]
}

#resource "google_compute_firewall" "icmp" {
  #name    = "${var.vpc_name}-firewall-icmp"
  #network = google_compute_network.vpc_network.id

  #allow {
    #protocol = "icmp"
  #}

  #target_tags   = ["${var.vpc_name}-firewall-icmp"]
  #source_ranges = ["0.0.0.0/0"]
#}
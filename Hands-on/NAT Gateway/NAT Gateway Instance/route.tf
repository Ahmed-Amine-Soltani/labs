resource "google_compute_route" "default" {
  name              = "network-route"
  dest_range        = "0.0.0.0/0"
  network           = google_compute_network.vpc_network.name
  next_hop_instance = google_compute_instance.nat-gateway-instance.id
  priority          = 900
  tags              = ["${var.vpc_name}-instance-without-external-ip"]
}
resource "google_compute_network" "this" {
  name                    = "handson-net"
  auto_create_subnetworks = false
}
resource "google_compute_subnetwork" "this" {
  name                     = "handson-asia-east1"
  ip_cidr_range            = "10.128.0.0/10"
  private_ip_google_access = true
  network                  = "${google_compute_network.this.self_link}"
}

resource "google_compute_firewall" "bastion" {
  name    = format("allow-bastion-ssh-%s", "${google_compute_network.this.name}")
  network = "${google_compute_network.this.name}"

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["bastion"]
}

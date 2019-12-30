
data "google_service_account" "agent" {
  account_id = "handson"
}

data "google_compute_network" "this" {
  name = "handson-net"
}
data "google_compute_subnetwork" "this" {
  name = "handson-asia-east1"
}


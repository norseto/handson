resource "google_compute_global_address" "this" {
  name = "hands-on-address"
}

resource "google_compute_address" "this" {
  name = "hands-on-region-address"
}

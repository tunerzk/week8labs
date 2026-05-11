
resource "google_compute_router_nat" "iowa" {
  name   = "iowa-nat"
  router = google_compute_router.iowa.name
  region = "us-central1"

  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ip_allocate_option             = "MANUAL_ONLY"

  subnetwork {
    name                    = google_compute_subnetwork.hqinternal.id
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }

  nat_ips = [google_compute_address.iowa.self_link]
}


resource "google_compute_address" "iowa" {
  name         = "iowa-nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
  region       = "us-central1"
}



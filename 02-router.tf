
resource "google_compute_router" "iowa" {
  name    = "iowa-router"
  region  = "us-central1"
  network = google_compute_network.main.id
}



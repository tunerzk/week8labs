
# Allow SSH access to instances with the "ssh-backend" tag
resource "google_compute_firewall" "ssh" {
  name    = "${google_compute_network.main.name}-allow-ssh"
  network = google_compute_network.main.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh-backend"]
}

# Allow ICMP (ping) to instances with the "ping-backend" tag
resource "google_compute_firewall" "ping" {
  name    = "${google_compute_network.main.name}-allow-ping"
  network = google_compute_network.main.name

  allow {
    protocol = "icmp"
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ping-backend"]
}

# Allow Google Cloud Load Balancer health checks
resource "google_compute_firewall" "allow_hc" {
  name = "fw-allow-health-check"

  allow {
    protocol = "tcp"
  }

  direction     = "INGRESS"
  network       = google_compute_network.main.id
  priority      = 1000
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  target_tags   = ["load-balanced-backend"]
}

# Allow traffic from the proxy-only subnet to backend instances
resource "google_compute_firewall" "allow_proxy" {
  name = "fw-allow-proxies"

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  direction     = "INGRESS"
  network       = google_compute_network.main.id
  priority      = 1000
  source_ranges = [google_compute_subnetwork.regional_proxy_subnet.ip_cidr_range]
  target_tags   = ["load-balanced-backend"]
}


resource "google_compute_subnetwork" "hqinternal" {
  name                     = "hqinternal"
  ip_cidr_range            = "10.100.10.0/24"
  region                   = "us-central1"
  network                  = google_compute_network.main.id
  private_ip_google_access = true
}

# Regional Proxy-Only Subnet 
# Required for Regional Application Load Balancer for traffic offloading
resource "google_compute_subnetwork" "regional_proxy_subnet" {
  name   = "regional-proxy-subnet"
  region = "us-central1"
  # apparently the cidr can be anything, google docs use 10.129.0.0/23 it seems
  # must match the fw rule to allow proxy-to-backend traffic source range though
  ip_cidr_range = "10.100.0.0/23"
  # This purpose reserves this subnet for regional Envoy-based load balancers
  purpose = "REGIONAL_MANAGED_PROXY"
  network = google_compute_network.main.id
  role    = "ACTIVE"
}

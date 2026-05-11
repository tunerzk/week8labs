# Client -> Static IP -> Fwd Rule -> HTTP Proxy -> URL Map (URL Map chooses backend service)

# Global Static IP
resource "google_compute_global_address" "lb_static_ip" {
  name = "lb-static-ip"
}

# Global Forwarding Rule
resource "google_compute_global_forwarding_rule" "lb" {
  name       = "lb-forwarding-rule"
  target     = google_compute_target_http_proxy.lb.id
  port_range = "80"
  ip_address = google_compute_global_address.lb_static_ip.address
}

# Global HTTP Proxy
resource "google_compute_target_http_proxy" "lb" {
  name    = "lb-http-proxy"
  url_map = google_compute_url_map.lb.id
}

# Global URL Map
resource "google_compute_url_map" "lb" {
  name            = "lb-url-map"
  default_service = google_compute_backend_service.lb.id
}



resource "google_compute_health_check" "lb" {
  name = "lb-health-check"

  http_health_check {
    request_path = "/index.html"
    port         = 80
  }
}


resource "google_compute_backend_service" "lb" {
  name          = "lb-backend-service"
  protocol      = "HTTP"
  port_name     = "webserver"
  health_checks = [google_compute_health_check.lb.id]

  backend {
    group = google_compute_region_instance_group_manager.app.instance_group
  }
}





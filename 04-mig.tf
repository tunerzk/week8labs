
data "google_compute_zones" "available" {
  status = "UP"
  
}


resource "google_compute_region_instance_group_manager" "app" {
  depends_on         = [google_compute_router_nat.iowa]
  name               = "app-mig"
  base_instance_name = "app"
  region = "us-central1"
  
  # Compute zones to be used for VM creation
  distribution_policy_zones = data.google_compute_zones.available.names

  # Instance Template argument for MIG
  version {
    instance_template = google_compute_region_instance_template.app_v2.id
  }

  # Set a port to be used by backend service
  named_port {
    name = "webserver"
    port = 80
  }

  



  # Autohealing Config
  auto_healing_policies {
    health_check      = google_compute_health_check.app.id
    initial_delay_sec = 300
  }
}

resource "google_compute_health_check" "app" {
  name = "app-health-check"

  http_health_check {
    port = 80
  }
}

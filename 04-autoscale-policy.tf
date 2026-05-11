
resource "google_compute_region_autoscaler" "app" {
  name = "app-autoscaler"
  # region = "" (optional if provider default is set)
  target = google_compute_region_instance_group_manager.app.id

  autoscaling_policy {
    max_replicas    = 4
    min_replicas    = 2
    cooldown_period = 60

    # 50% CPU for autoscaling event
    cpu_utilization {
      target = 0.5
    }
  }
}

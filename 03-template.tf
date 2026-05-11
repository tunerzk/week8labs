
# Google Compute Engine: Regional Instance Template
resource "google_compute_region_instance_template" "app_v2" {
  name        = "app-template-terraform-v2"
  region      = google_compute_subnetwork.hqinternal.region
  machine_type = "n2-standard-2"

  disk {
    source_image = "centos-cloud/centos-stream-10"
    boot         = true
    auto_delete  = true
    disk_size_gb = 100
  }

  network_interface {
    subnetwork = google_compute_subnetwork.hqinternal.id
  }

  metadata_startup_script = file("${path.module}/startup.sh")

  tags = ["load-balanced-backend"]
}

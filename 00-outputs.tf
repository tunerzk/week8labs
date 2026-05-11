


# ALB Frontend Static IP
output "lb_static_ip_address" {
  value = "http://${google_compute_global_address.lb_static_ip.address}"
}



output "compute_zones" {
  description = "Comma-separated compute zones"
  # convert set into string delimited by commas before output so its pretty
  value = join(", ", data.google_compute_zones.available.names)
}


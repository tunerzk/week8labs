
terraform {
  backend "gcs" {
    bucket = "week8lab-state-bucket"
    prefix = "terraform/050126"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }

    
  }
}


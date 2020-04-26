provider "google" {
  version     = "~> 3.16.0"
  credentials = var.credentials
  project     = var.project_id
  region      = var.region
}

# For google-beta features
provider "google-beta" {
  version     = "~> 3.16.0"
  credentials = var.credentials
  project     = var.project_id
  region      = var.region
}

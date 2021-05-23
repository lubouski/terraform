provider "google" {
  credentials = "key.json"
  project     = var.project_id
  region      = var.project_region
}

provider "google-beta" {
  credentials = "key.json"
  project     = var.project_id
  region      = var.project_region
}



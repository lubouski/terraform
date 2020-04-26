terraform {
 backend "gcs" {
   bucket  = "poetic-orb-tf-state"
   prefix  = "terraform/state/gke"
   credentials = "./terraform-ca-key.json"
 }
}

terraform {
 backend "gcs" {
   bucket  = "poetic-orb-tf-state"
   prefix  = "terraform/state"
   credentials = "/home/alex/terraform/terraform-sa-key.json"
 }
}

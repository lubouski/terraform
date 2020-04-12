// Configure the Google Cloud provider
provider "google" {
 credentials = file("/home/alex/terraform/terraform-sa-key.json")
 project     = var.gcp_project
 region      = "europe-west4"
}

output "ip" {
 value = google_compute_instance.default.network_interface.0.access_config.0.nat_ip
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "default" {
 name         = "tf-flask-vm-${random_id.instance_id.hex}"
 machine_type = "f1-micro"
 zone         = "europe-west4-c"

 boot_disk {
   initialize_params {
     image = "debian-cloud/debian-9"
   }
 }

 metadata = {
   ssh-keys = "alex:${file("~/.ssh/id_rsa.pub")}"
 }

// Make sure flask is installed on all new instances for later steps
 metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python-pip rsync; pip install flask"

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
}



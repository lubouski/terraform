## GKE with Istio service mesh and HTTPS lb
Terraform scripts to create GKE cluster with Istio service mesh nad HTTPS lb as source for IAP service.

### Important notice
To use these scripts please provide appropriate variables to variables.tf file.
And create `key.json` service account file.
Enable appropriate api at GCP project. 
Create domain name for your service, and link it with ip address which will be provided from terraform outputs at the end of the script execution. 

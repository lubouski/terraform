# Google Kubernetes Engine install sample

## Intro:
Terraform modules examples could be found at: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine

## Go-to commands:
$ provide terraform-ca-keyfile.json to root folder
$ review variables.auto.tfvars
$ terraform plan
$ terraform apply
$ terraform destroy

## Troubleshooting:
* `IN_USE_ADDRESSES` Quota Error:

  ```console
  ERROR: (gcloud.container.clusters.create) ResponseError: code=403, message=Insufficient regional quota to satisfy request for resource: "IN_USE_ADDRESSES". The request requires '9.0' and is short '1.0'. The regional quota is '8.0' with '8.0' available.
  ```

  1.  Open the GCP Console and navigate to `IAM & admin` -> `Quotas`.
  1.  Filter the quotas by selecting your region under `Location`.
  1.  Check the box next to `Compute Engine API In-use IP addresses global`,
      then click `EDIT QUOTAS`.
  1.  Follow the steps to increase the quota. Quotas are not immediately
      increased.

* `CPUS` Quota Error:

  ```console
  ERROR: (gcloud.container.node-pools.create) ResponseError: code=403, message=Insufficient regional quota to satisfy request for resource: "CPUS". The request requires '12.0' and is short '3.0'. The regional quota is '24.0' with '9.0' available.
  ```
  1.  Open the GCP Console and navigate to `IAM & admin` -> `Quotas`.
  1.  Filter the quotas by selecting your region under `Location`.
  1.  Check the box next to `Compute Engine API CPUs`, then click `EDIT QUOTAS`.
  1.  Follow the steps to increase the quota. Quotas are not immediately
      increased.



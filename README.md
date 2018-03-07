# Terraform examples

Terraform is a tool for building, changing, and versioning infrastructure safely and efficiently. Terraform can manage existing and popular service providers as well as custom in-house solutions.

## Getting Started

Install terrafrom from: 

* [Terraform:lates](https://www.terraform.io/downloads.html) - Download Terraform

```
sudo yum install unzip -y
```
```
wget https://releases.hashicorp.com/terraform/0.11.3/terraform_0.11.3_linux_amd64.zip
```
```
unzip terraform_0.11.3_linux_amd64.zip
```
```
sudo mv terraform /usr/local/bin/
```
```
terraform --version
```

## Run Terraform

```
terraform -h
```
```
terraform plan -var-file='path_to_tfvars_file.tfvars'
```
```
terraform apply -var-file='path_to_tfvars_file.tfvars'
```


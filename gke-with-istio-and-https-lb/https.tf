resource "local_file" "ingress" {
  depends_on = [google_container_cluster.primary]
  content = templatefile("${path.module}/manifests/tpl/ingress.tpl.yaml", {
    ip        = google_compute_global_address.default.name
    cert_name = google_compute_managed_ssl_certificate.default.name
  })

  filename = "./manifests/ingress.yaml"
}

resource "null_resource" "istio-injection" {
  depends_on = [google_container_cluster.primary]

  triggers = {
    endpoint = google_container_cluster.primary.endpoint
  }
  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone=${google_container_cluster.primary.location} && kubectl label namespace default istio-injection=enabled --overwrite"
  }
}

resource "null_resource" "service-gateway" {
  depends_on = [google_container_cluster.primary, local_file.ingress]

  triggers = {
    endpoint = google_container_cluster.primary.endpoint
    hash     = sha256(file("${path.module}/manifests/service-gateway.yaml"))
    hash     = sha256(local_file.ingress.content)
    hash     = sha256(file("${path.module}/scripts/backend-config.sh"))

    time = timestamp()
  }

  provisioner "local-exec" {
    command = "gcloud container clusters get-credentials ${google_container_cluster.primary.name} --zone=${google_container_cluster.primary.location}"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${path.module}/manifests/service-gateway.yaml"
  }

  provisioner "local-exec" {
    command = "kubectl apply -f ${local_file.ingress.filename}"
  }

  provisioner "local-exec" {
    command = "sh ${path.module}/scripts/backend-config.sh"
  }

  provisioner "local-exec" {
    command = "kubectl annotate -n istio-system service/istio-ingressgateway --overwrite cloud.google.com/backend-config='{\"default\": \"http-hc-config\"}' cloud.google.com/neg='{\"ingress\":true}'"
  }

}

resource "google_compute_global_address" "default" {
  name = "gke-ingress-ip"
}

output "ingress_ip" {
  value = google_compute_global_address.default.address
}


resource "google_compute_managed_ssl_certificate" "default" {
  depends_on = [google_compute_global_address.default]
  name       = "gke-ingress-cert"

  managed {
    domains = [var.ingress_domain]
  }
}


variable "host" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
  default     = "jenkins"
}

variable "cpu" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#cpu"
  default     = "500m"
}

variable "memory" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#memory"
  default     = "1Gi"
}

variable "storage" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/persistent_volume_claim.html#requests"
  default     = "5Gi"
}

variable "image" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#image"
}

variable "name" {
  description = "Name for all resources created within the namespace"
  default     = "this"
}

variable "namespace" {
  description = "Namespace to which all resources will be deployed"
}

variable "port" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#container_port"
  default     = "8080"
}

variable "ssl_redirect" {
  description = "https://kubernetes.github.io/ingress-nginx/user-guide/tls/#server-side-https-enforcement-through-redirect"
  default     = true
}

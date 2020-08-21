variable "host" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
  default     = ""
}

variable "resources" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#resources-1"

  default = {
    requests = {
      cpu    = 0
      memory = 0
    }

    limits = {
      cpu    = 2
      memory = "8Gi"
    }
  }
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

variable "service_type" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/service.html#type"
  default     = "ClusterIP"
}

variable "replicas" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#replicas"
  default     = 1
}

variable "secret_name" {
  description = "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#name"
  default     = ""
}

variable "config" {
  description = "Loaded as environment variables to the application pods"

  default = {
    this  = "that"
    those = "these"
  }
}

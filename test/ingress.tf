terraform {
  required_providers {
    kubernetes = {
      source = "hashicorp/kubernetes"
    }
  }
}

provider "kubernetes" {
  config_path = "~/.kube/config"
  insecure    = true
}

module "ingress" {
  source    = "../"
  name      = "this"
  namespace = kubernetes_namespace.ingress.metadata[0].name
  image     = "jenkins/jenkins:latest"
  host      = "ingress"
}

resource "kubernetes_namespace" "ingress" {
  metadata {
    name = "ingress"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

module "no_ingress" {
  source    = "../"
  name      = "this"
  namespace = kubernetes_namespace.no_ingress.metadata[0].name
  image     = "jenkins/jenkins:latest"
}

resource "kubernetes_namespace" "no_ingress" {
  metadata {
    name = "no-ingress"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

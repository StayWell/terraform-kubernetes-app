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

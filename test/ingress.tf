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

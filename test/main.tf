module "this" {
  source    = "../"
  name      = "this"
  namespace = kubernetes_namespace.this.metadata[0].name
}

resource "kubernetes_namespace" "this" {
  metadata {
    name = "this"
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

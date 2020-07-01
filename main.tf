resource "kubernetes_deployment" "this" {
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    selector {
      match_labels = {
        app = var.name
      }
    }

    template {
      metadata {
        labels = {
          app = var.name
        }
      }

      spec {
        container {
          name  = "this"
          image = var.image

          resources {
            requests {
              cpu    = var.cpu
              memory = var.memory
            }
          }

          env {
            name  = "VAR"
            value = "value"
          }

          port {
            container_port = var.port
          }
        }
      }
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "kubernetes_service" "this" {
  metadata {
    name      = "this"
    namespace = var.namespace
  }

  spec {
    type = "NodePort"

    selector = {
      app = var.name
    }

    port {
      name      = "http"
      port      = var.port
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

resource "kubernetes_ingress" "this" {
  metadata {
    name      = "this"
    namespace = var.namespace

    annotations = {
      "kubernetes.io/ingress.class"                    = "nginx"
      "nginx.ingress.kubernetes.io/ssl-redirect"       = var.ssl_redirect
      "nginx.ingress.kubernetes.io/force-ssl-redirect" = var.ssl_redirect
    }
  }

  spec {
    rule {
      host = var.host

      http {
        path {
          path = "/"

          backend {
            service_name = kubernetes_service.this.metadata[0].name
            service_port = kubernetes_service.this.spec[0].port[0].port
          }
        }
      }
    }

    tls {
      hosts = [var.host]
    }
  }

  lifecycle {
    ignore_changes = [
      metadata[0].annotations,
      metadata[0].labels
    ]
  }
}

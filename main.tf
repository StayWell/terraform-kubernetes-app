resource "kubernetes_deployment" "this" {
  wait_for_rollout = var.wait_for_rollout
  
  metadata {
    name      = var.name
    namespace = var.namespace
  }

  spec {
    replicas = var.replicas

    selector {
      match_labels = {
        selector = var.name
      }
    }

    template {
      metadata {
        labels = {
          selector = var.name
        }
      }

      spec {
        container {
          name  = "this"
          image = var.image

          resources {
            requests {
              cpu    = var.resources.requests.cpu
              memory = var.resources.requests.memory
            }

            limits {
              cpu    = var.resources.limits.cpu
              memory = var.resources.limits.memory
            }
          }

          port {
            container_port = var.port
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe == null ? [ ] : [ var.liveness_probe ]
            content {
              http_get {
                path = liveness_probe.value["path"]
                port = var.port

                http_header {
                  name  = "X-Whs-Kubernetes-Liveness-Probe"
                  value = "true"
                }
              }

              initial_delay_seconds = liveness_probe.value["initial_delay"]
              period_seconds        = liveness_probe.value["frequency"]
              success_threshold     = liveness_probe.value["success_threshold"]
              failure_threshold     = liveness_probe.value["failure_threshold"]
              timeout_seconds       = liveness_probe.value["timeout"]
            }
          }

          dynamic "env" {
            for_each = var.config

            content {
              name  = env.key
              value = env.value
            }
          }

          dynamic "env_from" {
            for_each = var.secrets

            content {
              secret_ref {
                name = env_from.value
              }
            }
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
    name      = var.name
    namespace = var.namespace
  }

  spec {
    type = var.service_type

    selector = {
      selector = var.name
    }

    port {
      port = var.port
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
  count = var.host == "" ? 0 : 1

  metadata {
    name      = var.name
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
            service_name = var.name
            service_port = var.port
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

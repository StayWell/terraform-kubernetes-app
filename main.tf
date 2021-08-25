resource "kubernetes_deployment" "this" {
  wait_for_rollout = var.wait_for_rollout

  metadata {
    name      = var.name
    namespace = var.namespace
  }

  depends_on = [var.namespace]

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

        # Applies to all containers in the pod.
        termination_grace_period_seconds = var.termination_grace_period_seconds + var.pre_stop_sleep_seconds

        container {
          name  = "this"
          image = var.image

          resources {
            requests = {
              cpu    = var.cpu_request
              memory = var.mem_request
            }

            limits = {
              cpu    = var.cpu_limit
              memory = var.mem_limit
            }
          }

          port {
            container_port = var.port
          }

          lifecycle {
            pre_stop {
              exec {
                command = ["sleep", var.pre_stop_sleep_seconds]
              }
            }
          }

          dynamic "liveness_probe" {
            for_each = var.liveness_probe == null || var.disable_liveness_probe ? [] : [var.liveness_probe]
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

          dynamic "startup_probe" {
            for_each = var.startup_probe == null || var.disable_startup_probe ? [] : [var.startup_probe]
            content {
              http_get {
                path = startup_probe.value["path"]
                port = var.port

                http_header {
                  name  = "X-Whs-Kubernetes-Startup-Probe"
                  value = "true"
                }
              }

              initial_delay_seconds = startup_probe.value["initial_delay"]
              period_seconds        = startup_probe.value["frequency"]
              success_threshold     = startup_probe.value["success_threshold"]
              failure_threshold     = startup_probe.value["failure_threshold"]
              timeout_seconds       = startup_probe.value["timeout"]
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

  depends_on = [var.namespace, kubernetes_deployment.this]

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

  depends_on = [
    var.namespace,
    kubernetes_deployment.this,
    kubernetes_service.this,
    kubernetes_ingress.this
  ]

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

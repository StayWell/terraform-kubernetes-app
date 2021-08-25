
variable "cpu_limit" {
  description = "The maximum CPU. Format is Xm, which is X thousandths of a CPU, e.g. 2000m would be 2 CPUs. The default is 2 CPUs. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
  default     = "2000m"
}

variable "cpu_request" {
  description = "The amount of CPU to request. Format is Xm, which represent X thousandths of a CPU, e.g. 500m would be half a CPU. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
  default     = 0
}

variable "host" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/ingress.html#host"
  default     = ""
}

variable "disable_liveness_probe" {
  description = "If true, omits the liveness probe from the app's definition. Default is \"false\"."
  default     = false
}

variable "disable_startup_probe" {
  description = "If true, omits the startup probe from the app's definition. Default is \"false\"."
  default     = false
}

variable "image" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#image"
}

variable "liveness_probe" {
  description = "The URL to use in the app's liveness probe."
  type = object({
    failure_threshold = number
    frequency         = number
    initial_delay     = number
    path              = string
    success_threshold = number
    timeout           = number
  })
  default = null
}

variable "mem_limit" {
  description = "The maximum amount of memory to reserve. Default is 8Gi. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
  default     = "8Gi"
}

variable "mem_request" {
  description = "The amount of memory to request. https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/"
  default     = 0
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

variable "pre_stop_sleep_seconds" {
  description = "The number of seconds to sleep before stopping the app. This gives Kubernetes time to stop sending traffic to the app. The default is not to sleep."
  type        = number
  default     = 0
}

variable "ssl_redirect" {
  description = "https://kubernetes.github.io/ingress-nginx/user-guide/tls/#server-side-https-enforcement-through-redirect"
  default     = true
}

variable "service_type" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/service.html#type"
  default     = "ClusterIP"
}

variable "startup_probe" {
  description = "Configuration for the app's startup probe, if any."
  type = object({
    failure_threshold = number
    frequency         = number
    initial_delay     = number
    path              = string
    success_threshold = number
    timeout           = number
  })
  default = null
}

variable "replicas" {
  description = "https://www.terraform.io/docs/providers/kubernetes/r/deployment.html#replicas"
  default     = 1
}

variable "secrets" {
  description = "List of secret names from which env_from blocks will be generated"
  default     = []
}

variable "termination_grace_period_seconds" {
  description = "The amount of time Kubernetes should wait before forcibly killing a pod. Default is 30 seconds plus  `pre_stop_sleep_seconds`."
  type        = number
  default     = 30
}

variable "wait_for_rollout" {
  description = "https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/deployment#wait_for_rollout"
  default     = true
}

variable "config" {
  description = "Loaded as environment variables to the application pods"

  default = {
    this  = "that"
    those = "these"
  }
}

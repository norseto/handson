resource "kubernetes_service" "this" {
  metadata {
    name      = "nginx-service"
    namespace = "handson"

  }
  spec {
    selector = {
      app = "nginx"
    }
    port {
      port        = 8080
      target_port = 80
    }

    type             = "LoadBalancer"
    load_balancer_ip = "${data.google_compute_address.this.address}"
  }
}

output "lbip" {
  value = "${data.google_compute_address.this.address}"
}

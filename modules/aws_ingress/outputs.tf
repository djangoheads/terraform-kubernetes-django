output "endpoint" {
  value = kubernetes_ingress_v1.main_ingress[0].status[0].load_balancer[0].ingress[0].hostname
}

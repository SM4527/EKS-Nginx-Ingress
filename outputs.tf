#output "load-balancer-hostname" {
#  value = data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].hostname
#}
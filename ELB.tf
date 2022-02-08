# Get DNS name of the ELB created by the Ingress Controller.
data "kubernetes_service" "ingress-nginx" {
  metadata {
    namespace = "ingress"
    name = "ingress-nginx-controller"
  }

  depends_on = [helm_release.ingress-nginx]

}

data "aws_lb" "ingress-nginx" {
  name = regex(
    "(^[^-]+)",
    data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].hostname
  )[0]
# name = data.kubernetes_service.ingress-nginx.status[0].load_balancer[0].ingress[0].hostname
}
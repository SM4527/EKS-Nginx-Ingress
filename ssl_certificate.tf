resource "aws_acm_certificate" "ssl_certificate" {
  domain_name = var.your_domain_name
  subject_alternative_names = ["*.${var.your_domain_name}"]
  validation_method = "EMAIL"
  #validation_method = "DNS"
  
  lifecycle {
    create_before_destroy = true
  }
 
  tags = {
    Domain_Name = var.your_domain_name
    EKS_Cluster_name = data.terraform_remote_state.eks.outputs.EKS_cluster_name
    terraform = "true"
  }
  
}

resource "aws_acm_certificate_validation" "cert_validation" {
  certificate_arn = "${aws_acm_certificate.ssl_certificate.arn}"
# validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
# validation_record_fqdns = ["${aws_route53_record.ingress-nginx.fqdn}",]
}
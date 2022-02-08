locals {
  env = "${terraform.workspace}"

  region_map = {
    default = "us-east-1"
  }
 
  region = "${lookup(local.region_map, local.env)}"

  kubeconfig = yamlencode({
    apiVersion      = "v1"
    kind            = "Config"
    current-context = "${var.AWS_PROFILE}"
    clusters = [{
      name = data.terraform_remote_state.eks.outputs.EKS_cluster_id
      cluster = {
        certificate-authority-data = data.terraform_remote_state.eks.outputs.EKS_cluster_CA_data
        server                     = data.terraform_remote_state.eks.outputs.EKS_cluster_endpoint
      }
    }]
    contexts = [{
      name = "${var.AWS_PROFILE}"
      context = {
        cluster = data.terraform_remote_state.eks.outputs.EKS_cluster_id
        user    = "${var.AWS_PROFILE}"
      }
    }]
    users = [{
      name = "${var.AWS_PROFILE}"
      user = {
        exec = {
          apiVersion = "client.authentication.k8s.io/v1alpha1"
          args        = ["--region","${local.region}","eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.EKS_cluster_name ]
          command     = "aws"
          env = [{
            "name" = "AWS_PROFILE"
            "value" = "${var.AWS_PROFILE}"
          }]
        }
      }
    }]
  })


}
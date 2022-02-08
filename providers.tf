provider "aws" {
  region = "${local.region}"
  profile = "${var.AWS_PROFILE}"
}

provider "helm" {
  kubernetes {
    host                   = data.terraform_remote_state.eks.outputs.EKS_cluster_endpoint
#    token                  = data.terraform_remote_state.eks.outputs.EKS_cluster_auth_token
    cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.EKS_cluster_CA_data)
    config_path = "/code/kubeconfig_${terraform.workspace}"
    exec {
      api_version = "client.authentication.k8s.io/v1alpha1"
      args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.EKS_cluster_name]
      command     = "aws"
    }
  # load_config_file       = false
  }
}

provider "kubernetes" {
  host                   = data.terraform_remote_state.eks.outputs.EKS_cluster_endpoint
  cluster_ca_certificate = base64decode(data.terraform_remote_state.eks.outputs.EKS_cluster_CA_data)
  exec {
    api_version = "client.authentication.k8s.io/v1alpha1"
    args        = ["eks", "get-token", "--cluster-name", data.terraform_remote_state.eks.outputs.EKS_cluster_name]
    command     = "aws"
  }
  config_path = "/code/kubeconfig_${terraform.workspace}"
# load_config_file       = false
}
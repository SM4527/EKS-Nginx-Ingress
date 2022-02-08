resource "local_file" "kubeconfig_EKS_Cluster" {
    content  = "${local.kubeconfig}"
#   filename = "kubeconfig_${local.cluster_name}_${terraform.workspace}"
    filename = "kubeconfig_${terraform.workspace}"
}
<p align="center">

![Kubernetes](https://img.shields.io/badge/kubernetes-%23326ce5.svg?style=for-the-badge&logo=kubernetes&logoColor=white) ![AWS](https://img.shields.io/badge/AWS-%23FF9900.svg?style=for-the-badge&logo=amazon-aws&logoColor=white) ![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white) ![Docker](https://img.shields.io/badge/docker-%230db7ed.svg?style=for-the-badge&logo=docker&logoColor=white) ![Nginx](https://img.shields.io/badge/nginx-%23009639.svg?style=for-the-badge&logo=nginx&logoColor=white) ![Shell Script](https://img.shields.io/badge/shell_script-%23121011.svg?style=for-the-badge&logo=gnu-bash&logoColor=white)

![Stars](https://img.shields.io/github/stars/SM4527/EKS-Nginx-Ingress?style=for-the-badge) ![Forks](https://img.shields.io/github/forks/SM4527/EKS-Nginx-Ingress?style=for-the-badge) ![Issues](https://img.shields.io/github/issues/SM4527/EKS-Nginx-Ingress?style=for-the-badge) ![License](https://img.shields.io/github/license/SM4527/EKS-Nginx-Ingress?style=for-the-badge)

</p>

# Project Title

EKS-Nginx-Ingress [![Tweet](https://img.shields.io/twitter/url/http/shields.io.svg?style=social)](https://twitter.com/intent/tweet?text=EKS%20-%20Nginx%20-%20Ingress&url=https://github.com/SM4527/EKS-Nginx-Ingress)

## Description

Deploy Nginx Ingress on an EKS cluster using Terraform and Helm.

<p align="center">

![image](https://user-images.githubusercontent.com/78129381/153622350-dcaf792f-0704-4426-916a-1551dd9fe8b9.png)

</p>

## Getting Started

### Dependencies

* Docker
* AWS user with programmatic access and high privileges 
* Linux terminal
* Deploy an [EKS K8 Cluster](https://github.com/SM4527/EKS-Terraform) with Self managed Worker nodes on AWS using Terraform.

### Installing

* Clone the repository
* Set environment variable TF_VAR_AWS_PROFILE
* Review terraform variable values in variables.tf, locals.tf
* Override values in the Helm chart through the "chart_values.yaml" file
* Update kubernetes.tf with the AWS S3 bucket name and key name from the output of the [EKS K8 Cluster](https://github.com/SM4527/EKS-Terraform/blob/master/outputs.tf)

### Executing program

* Configure AWS user with AWS CLI.

```
docker-compose run --rm aws configure --profile $TF_VAR_AWS_PROFILE

docker-compose run --rm aws sts get-caller-identity
```

* Specify appropriate Terraform workspace.

```
docker-compose run --rm terraform workspace show

docker-compose run --rm terraform workspace select default
```

* Run Terraform apply to create the EKS cluster, k8 worker nodes and related AWS resources.

```
./run-docker-compose.sh terraform init

./run-docker-compose.sh terraform validate

./run-docker-compose.sh terraform plan

./run-docker-compose.sh terraform apply
```

* Update the annotation "service.beta.kubernetes.io/aws-load-balancer-ssl-cert" of chart_values.yaml with the ARN of the ACM Certificate.

* Verify Domain ownership by responding to the email received from AWS at the registered email address. This is required for terraform to proceed with ACM and Route 53 infrastructure creation.

* Verify ingress-nginx-controller deployment is running and ingress-nginx-controller service lists the AWS ELB in External-IP.

```
./run-docker-compose.sh kubectl get all -A | grep -i ingress
```

## Help

* ingress-nginx controller service - SyncLoadBalancerFailed

```
Issue: ingress-nginx controller service - SyncLoadBalancerFailed

Fix:
Added below tag to VPC Public subnets.
"kubernetes.io/role/elb" = 1
```

Reference: https://aws.amazon.com/premiumsupport/knowledge-center/eks-load-balancers-troubleshooting/

* Failed to ensure load balancer. Multiple tagged security groups found for instance

```
Issue: failed to ensure load balancer: Multiple tagged security groups found for instance: ensure only the k8s security group is tagged; the tagged groups were worker-group-1-node-group-* & Default-EKS-Cluster-node-*

Fix: add the below null tag to worker node defaults.
self_managed_node_group_defaults = {
    security_group_tags = {
      "kubernetes.io/cluster/${local.cluster_name}" = null
```

Reference: https://github.com/terraform-aws-modules/terraform-aws-eks/issues/1810

## Authors

[Sivanandam Manickavasagam](https://www.linkedin.com/in/sivanandammanickavasagam)

## Version History

* 0.1
    * Initial Release

## License

This project is licensed under the MIT License - see the LICENSE file for details

## Repo rosters

### Stargazers

[![Stargazers repo roster for @SM4527/EKS-Nginx-Ingress](https://reporoster.com/stars/dark/SM4527/EKS-Nginx-Ingress)](https://github.com/SM4527/EKS-Nginx-Ingress/stargazers)


# Project Title

EKS-Nginx-Ingress

## Description

Deploy Nginx Ingress on an EKS cluster using Terraform and Helm.

## Getting Started

### Dependencies

* docker & docker-compose
* aws user with programmatic access and high privileges 
* linux terminal
* Deploy an [EKS K8 Cluster](https://github.com/SM4527/EKS-Terraform) with Self managed Worker nodes on AWS using Terraform.

### Installing

* clone the repository
* set environment variable TF_VAR_AWS_PROFILE
* review terraform variable values in variables.tf, locals.tf
* override values in the Helm chart through the "chart_values.yaml" file
* update kubernetes.tf with the AWS S3 bucket name and key name from the output of the [EKS K8 Cluster](https://github.com/SM4527/EKS-Terraform/blob/master/outputs.tf)

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


# hashistack-on-eks
Hashicorp's toolset self-hosted on AWS Elastic Kubernetes Sevice (EKS)


        .github
        └── workflows
            ├── first-terraform-plan.yml
            └── later-terraform-apply.yml

        └── develop
                ├── acm
                ├── asg-consul
                ├── aws-alb-ctrl
                ├── ecr
                ├── eks-insights
                ├── eks-ocean-cluster
                ├── helm-alb-ctrl
                ├── helm-cert-manager
                ├── helm-consul
                ├── iam-oidc
                ├── iam-spotinst
                ├── private-witold-demo-hz
                ├── s3-backend
                └── vpc


        modules
        ├── acm
        ├── asg-with-lt
        ├── aws-alb-ctrl
        ├── aws-eks-cluster
        ├── aws-eks-insights
        ├── aws-r53-records
        ├── consul
        ├── data-vpc
        ├── ecr
        ├── generic-helm-release
        ├── iam-oidc
        ├── iam-spotinst
        ├── ingress-alb-cname
        ├── k8s-namespace
        ├── k8s-secret
        ├── k8s-service-lb
        ├── s3-backend
        ├── spotinst-eks-ocean
        ├── spotinst-ocean-controller
        ├── vpc
        ├── vpn-client-endpoint
        └── vpn-site-to-site

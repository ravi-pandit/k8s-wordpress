ALB Mannual setup Document for AWS :- 

To deploy the AWS Load Balancer Controller to an Amazon EKS cluster
1. Download IAM policy and Create an IAM policy 
    - curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy.json
    - aws iam create-policy \
        --policy-name AWSLoadBalancerControllerIAMPolicy \
        --policy-document file://iam_policy.json

2. Create a Kubernetes service account and attache role
    - View your cluster's OIDC provider URL
        - aws eks describe-cluster --name eks-demo --query "cluster.identity.oidc.issuer" --output text
            https://oidc.eks.ap-south-1.amazonaws.com/id/B01A9D92AC0CDD63890F077686DD3A40
    - create the load-balancer-role-trust-policy.json file
        cat >load-balancer-role-trust-policy.json <<EOF
        {
            "Version": "2012-10-17",
            "Statement": [
                {
                    "Effect": "Allow",
                    "Principal": {
                        "Federated": "arn:aws:iam::187451058634:oidc-provider/oidc.eks.ap-south-1.amazonaws.com/id/B01A9D92AC0CDD63890F077686DD3A40"
                    },
                    "Action": "sts:AssumeRoleWithWebIdentity",
                    "Condition": {
                        "StringEquals": {
                            "oidc.eks.ap-south-1.amazonaws.com/id/B01A9D92AC0CDD63890F077686DD3A40:aud": "sts.amazonaws.com",
                            "oidc.eks.ap-south-1.amazonaws.com/id/B01A9D92AC0CDD63890F077686DD3A40:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                        }
                    }
                }
            ]
        }
        EOF
    - Create the IAM role
        aws iam create-role \
            --role-name AmazonEKSLoadBalancerControllerRole \
            --assume-role-policy-document file://"load-balancer-role-trust-policy.json"

    - Attach the required Amazon EKS managed IAM policy to the IAM role
        aws iam attach-role-policy \
            --policy-arn arn:aws:iam::187451058634:policy/AWSLoadBalancerControllerIAMPolicy \
            --role-name AmazonEKSLoadBalancerControllerRole

    - create the aws-load-balancer-controller-service-account.yaml file
        cat >aws-load-balancer-controller-service-account.yaml <<EOF
        apiVersion: v1
        kind: ServiceAccount
        metadata:
          labels:
            app.kubernetes.io/component: controller
            app.kubernetes.io/name: aws-load-balancer-controller
          name: aws-load-balancer-controller
          namespace: kube-system
          annotations:
            eks.amazonaws.com/role-arn: arn:aws:iam::111122223333:role/AmazonEKSLoadBalancerControllerRole
        EOF

    - Create the Kubernetes service account on your cluster
        kubectl apply -f aws-load-balancer-controller-service-account.yaml

3. AWS ALB Ingress Controller for Kubernetes
    - Check to see if the controller is currently installed
        kubectl get deployment -n kube-system alb-ingress-controller
    - AWS Load Balancer Controller access to the resources that were created by the ALB Ingress Controller for Kubernetes
        curl -o iam_policy_v1_to_v2_additional.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.4.4/docs/install/iam_policy_v1_to_v2_additional.json
    - Create the IAM policy and note the ARN that is returned
        aws iam create-policy \
            --policy-name AWSLoadBalancerControllerAdditionalIAMPolicy \
            --policy-document file://iam_policy_v1_to_v2_additional.json
    - Attach the IAM policy to the IAM role that you created
        aws iam attach-role-policy   --role-name AmazonEKSLoadBalancerControllerRole  --policy-arn arn:aws:iam::187451058634:policy/AWSLoadBalancerControllerAdditionalIAMPolicy

4. Install cert-manager
    - If your nodes have access to the quay.io container registry, install cert-manager to inject certificate configuration into the webhooks
        kubectl apply \
            --validate=false \
            -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml
    - Install the controller
        curl -Lo v2_4_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_full.yaml
    - Make the following edits to the file
        sed -i.bak -e '480,488d' ./v2_4_4_full.yaml
    - Replace your-cluster-name in the Deployment spec section of the file with the name of your cluster by replacing my-cluster with the name of your cluster
        sed -i.bak -e 's|your-cluster-name|eks-demo|' ./v2_4_4_full.yaml
    - Apply the file
        kubectl apply -f v2_4_4_full.yaml
    - Download the IngressClass and IngressClassParams manifest to your cluster
        curl -Lo v2_4_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.4.4/v2_4_4_ingclass.yaml
    - Apply the manifest to your cluster
        kubectl apply -f v2_4_4_ingclass.yaml

5. Verify that the controller is installed
- kubectl get deployment -n kube-system aws-load-balancer-controller



ip-10-0-0-206.ap-south-1.compute.internal/10.0.0.206

AWS_STS_REGIONAL_ENDPOINTS

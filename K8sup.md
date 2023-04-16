# Get the RDS Database Endpoint :- 
- aws rds describe-db-instances --db-instance-identifier terraform-laravelk8s-1
Here you will find the Address so copy that address and add that value WP_WT_MYSQL_HOST in wordpress-configmap.yaml

# get the RDS Database:- 
aws secretsmanager get-secret-value --secret-id terraform-password-3ZKA65vnoZWZUoce 
Here you will find the SecretString so copy that SecretString and add that value for WP_WT_MYSQL_PASSWORD in  wordpress-configmap.yaml

# After need to update the context for Kubernetes:- 
Get the Account Number use of below command:- 

- aws sts get-caller-identity
Update the kubernetes context:- 
- aws eks update-kubeconfig --region ap-south-1 --name eks-demo

Get OIDC and Update trust policy 
- aws eks describe-cluster --name eks-demo --query "cluster.identity.oidc.issuer" --output text

update the OIDC value in Roles > select "AmazonEKSLoadBalancerControllerRole" > Trust relationships > update the OIDC Unique Number.

# Install certmanager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.10.0/cert-manager.yaml

https://github.com/cert-manager/cert-manager/releases/tag/v1.11.0/cert-manager.yaml

kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.5.4/cert-manager.yaml

Deploy the AWS Load balancer controller
1234567

Now deploy all Kubernetes config files.



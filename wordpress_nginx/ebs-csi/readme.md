https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html

step1:-
aws eks describe-cluster \
  --name eks-demo \
  --query "cluster.identity.oidc.issuer" \
  --output text

https://oidc.eks.ap-south-1.amazonaws.com/id/95E66CA9DA464120C22291EDE1CB6732

step2:-

aws iam create-role \
  --role-name AmazonEKS_EBS_CSI_DriverRole \
  --assume-role-policy-document file://"aws-ebs-csi-driver-trust-policy.json"

Step3:-

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
  --role-name AmazonEKS_EBS_CSI_DriverRole

Step4:-

kubectl annotate serviceaccount ebs-csi-controller-sa \
    -n kube-system \
    eks.amazonaws.com/role-arn=arn:aws:iam::187451058634:role/AmazonEKS_EBS_CSI_DriverRole

Step5:-
kubectl rollout restart deployment ebs-csi-controller -n kube-system


aws eks create-addon --cluster-name eks-demo --addon-name aws-ebs-csi-driver \
  --service-account-role-arn arn:aws:iam::187451058634:role/AmazonEKS_EBS_CSI_DriverRole


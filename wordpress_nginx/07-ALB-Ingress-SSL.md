#07-ALB-Ingress-SSL.yml
# Annotations Reference:  https://kubernetes-sigs.github.io/aws-alb-ingress-controller/guide/ingress/annotation/
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: ingress-usermgmt-restapp-service
  labels:
    app: usermgmt-restapp
  annotations:
    # Ingress Core Settings  
    kubernetes.io/ingress.class: "alb"
    alb.ingress.kubernetes.io/scheme: internet-facing
    # Health Check Settings
    alb.ingress.kubernetes.io/healthcheck-protocol: HTTP 
    alb.ingress.kubernetes.io/healthcheck-port: traffic-port
    #Important Note:  Need to add health check path annotations in service level if we are planning to use multiple targets in a load balancer    
    #alb.ingress.kubernetes.io/healthcheck-path: /usermgmt/health-status
    alb.ingress.kubernetes.io/healthcheck-interval-seconds: '15'
    alb.ingress.kubernetes.io/healthcheck-timeout-seconds: '5'
    alb.ingress.kubernetes.io/success-codes: '200'
    alb.ingress.kubernetes.io/healthy-threshold-count: '2'
    alb.ingress.kubernetes.io/unhealthy-threshold-count: '2'
    ## SSL Settings
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS":443}, {"HTTP":80}]'
    alb.ingress.kubernetes.io/certificate-arn: arn:aws:acm:us-east-1:180789647333:certificate/9f042b5d-86fd-4fad-96d0-c81c5abc71e1
    #alb.ingress.kubernetes.io/ssl-policy: ELBSecurityPolicy-TLS-1-1-2017-01 #Optional (Picks default if not used)    
spec:
  rules:
    #- host: ssldemo.kubeoncloud.com    # SSL Setting (Optional only if we are not using certificate-arn annotation)
    - http:
        paths:
          - path: /app1/*
            backend:
              serviceName: app1-nginx-nodeport-service
              servicePort: 80                        
          - path: /app2/*
            backend:
              serviceName: app2-nginx-nodeport-service
              servicePort: 80            
          - path: /*
            backend:
              serviceName: usermgmt-restapp-nodeport-service
              servicePort: 8095              
# Important Note-1: In path based routing order is very important, if we are going to use  "/*", try to use it at the end of all rules.         
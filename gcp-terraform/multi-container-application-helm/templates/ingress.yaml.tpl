apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: ingress-service
  annotations:
     external-dns.alpha.kubernetes.io/hostname: ahmed-app-pfe.innovorder.io
     cert-manager.io/cluster-issuer: letsencrypt-prod
     acme.cert-manager.io/http01-edit-in-place: "true"
spec:
  tls: # < placing a host in the TLS config will indicate a certificate should be created
  - hosts:
    - ahmed-app-pfe.innovorder.io
    secretName: sampleapp-cert-secret
  rules:
   - http:
      paths:
      - pathType: ImplementationSpecific
        path: /*
        backend:
          service:
            name: client-service
            port: 
              number: 3000
      - pathType: ImplementationSpecific
        path: /api/*
        backend:
          service:
            name: server-service
            port:
              number: 5000
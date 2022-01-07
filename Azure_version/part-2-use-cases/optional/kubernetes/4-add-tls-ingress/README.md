# Azure Kubernetes - Setup TLS ingress

>Documentation on the experiments carried out during the LabWeek 2022 on the AWK Cloud Lab

>Main contact: Werner Baumann (werner.baumann@awk.ch)

> go back to [Azure Kubernetes](../README.md)

## Setting up TLS ingress with own certificate {#setup-tls-ingress-own}
As we have seen, we need to provide the ingress with our own certificate. This can be done as follows (see also https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls#generate-tls-certificates).

### Add an A record to your DNS zone
In order that the Ingress Controller has a DNS name (only available as long as the service is **not** deleted), issue the following command:
```
    az network dns record-set a add-record \
    --resource-group rg-euwe-dev-labweek22-darkclouds \
    --zone-name aks-testcluster \
    --record-set-name "*" \
    --ipv4-address 20.82.67.215
```

### Create own certificate, store as a secret into AKS
Creating our own certificate can be done easily. Open a shell and issue the following command
```
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out ingress-nginx.crt \
    -keyout ingress-nginx.key \
    -subj "/CN=aks-testcluster/OU=ingress-nginx/O=awk/c=ch"
```
This results in a RSA public and private key in our current directory. Now, these have to be made available to our AKS cluster as a secret:
```
    kubectl create secret tls ingress-nginx \
    --namespace ingress-nginx \
    --key ingress-nginx.key \
    --cert ingress-nginx.crt
```
Now we configure the ingress to use this secret. This is done with an ingress controller configuration that looks like this:
```yaml
    apiVersion: networking.k8s.io/v1
    kind: Ingress
    metadata:
    name: azure-vote-front-ingress
    annotations:
        kubernetes.io/ingress.class: nginx
        nginx.ingress.kubernetes.io/ssl-redirect: "false"
        nginx.ingress.kubernetes.io/use-regex: "true"
        nginx.ingress.kubernetes.io/rewrite-target: /$1
    spec:
    rules:
    - http:
        paths:
        - path: /vote(/|$)(.*)
            pathType: Prefix
            backend:
            service:
                name: azure-vote-front
                port:
                number: 80
        - path: /(.*)
            pathType: Prefix
            backend:
            service:
                name: azure-vote-front
                port:
                number: 80
```
Important points to note in the configuration file:
- the Service ```azure-vote-front``` is now configured to be of type ```ClusterIP```, which means it has no longer an external IP address provided by the former type ```LoadBalancer```
- we add an Ingress resource that directs traffic from the ingress controller to our application, either when using our new ```<app-path>```
```/vote```

Apply this configuration:
```
    kubectl apply -f azure-vote-http-ingress.yaml
```
and you get 
```
    service/azure-vote-front configured
    ingress.ne tworking.k8s.io/azure-vote-front-ingress created
```
TODO





## Setting up TLS ingress with Credential Manager {#setup-tls-ingress-cred-manager}
In order that the certificates remain valid, they need to be taken care of and renewed before they expire. To achieve this, we will use the Credential Manager and certificates issued by Let's Encrypt!. 

However, you could set this all up using another PKI with issues your own certificates .. but this another case. The steps to be taken are similar, the configuration might differ in some parts and will differ in the values configured. For more information, head over to https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls.

TODO
- how to intall Credential Manager?
- how to configre renewal for Certs?
- see 




Return to the main article [Azure Kubernetes](../README.md#remove-resources) and [remove all the resources from this example](../5-remove-resources/README.md).

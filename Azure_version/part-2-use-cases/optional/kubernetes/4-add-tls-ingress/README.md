# Azure Kubernetes - Setup TLS ingress

>Documentation on the experiments carried out during the LabWeek 2022 on the AWK Cloud Lab

>Main contact: Werner Baumann (werner.baumann@awk.ch)

> go back to [Azure Kubernetes](../README.md)

## Setting up TLS ingress with own certificate {#setup-tls-ingress-own}
As we have seen, we need to provide the ingress with a certificate of our own. This can be done in two ways:
- issue own certificate (see also https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls#generate-tls-certificates)
- use credential manager (see also https://docs.microsoft.com/en-us/azure/aks/ingress-tls?tabs=azure-cli)

But before that, make sure our application can be reached at a DNS name, not only by public IP address.

### Add an A record to your DNS zone
In order that the Ingress Controller has a DNS name (only available as long as the service is **not** deleted), go through the following steps:
- on the Azure portal, find the automatically created resource group of your AKS cluster in your subscription.
![resources inside the managed resource group](resources-inside-managed-RG.png)
Then, move on to the configuration of the public IP address:
![configure public IP address with DNS name](configure-public-ip-address.png)


alternatively, do all this by CLI. get the ID of your public IP address (in our case, 20.82.67.215).
```
    az network public-ip list --query "[?ipAddress!=null]|[?contains(ipAddress, '20.82.67.215')].[id]" --output tsv
```
gives you the ID of the public IP address objekt which we need to alter.
```
    az network public-ip update --ids /subscriptions/35d6c10f-be8b-4d64-8771-7c4d9be0e318/resourceGroups/mc_rg-euwe-dev-labweek22-darkclouds_aks-testcluster_westeurope/providers/Microsoft.Network/publicIPAddresses/kubernetes-a25f71f443a0e41e588e8417e65b0719 --dns-name aks-testcluster
```
sets the DNS name for our public IP address to "aks-testcluster". Note that in the JSON returned, you find your fully qualified domain name (FQDN is in the property dnsSettings.fqdn):
```json
{
  ...
  "dnsSettings": {
    "domainNameLabel": "aks-testcluster",
    "fqdn": "aks-testcluster.westeurope.cloudapp.azure.com",
    "reverseFqdn": null
  },
  ...
}
```

After this step, our appliction is now reachable at our DNS name, not only by IP address:
![configure public IP address with DNS name](test-application-with-dns.png)


### Create own certificate, store as a secret into AKS
Creating our own certificate can be done easily. Open a shell and issue the following command
```
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
    -out ingress-nginx.crt \
    -keyout ingress-nginx.key \
    -subj "/CN=aks-testcluster.westeurope.cloudapp.azure.com/O=ingress-nginx"
```
This results in a RSA public and private key in our current directory. Now, these have to be made available to our AKS cluster as a secret:
```
    kubectl create secret tls ingress-nginx \
    --namespace ingress-nginx \
    --key ingress-nginx.key \
    --cert ingress-nginx.crt
```

### Configure Ingress Controller to use TLS
Now we configure the ingress to use the secret. This is done with an ingress controller configuration that looks like this:
```yaml
    apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: azure-vote-front-ingress
  annotations:
    kubernetes.io/ingress.class: nginx
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/use-regex: "true"
    nginx.ingress.kubernetes.io/rewrite-target: /$1
spec:
  tls:
  - hosts:
    - aks-testcluster.westeurope.cloudapp.azure.com
    secretName: ingress-nginx
  rules:
  - host: aks-testcluster.westeurope.cloudapp.azure.com
    http:
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
Note that
- there is a new section ```tls```
- the ```hosts``` in the section ```tls``` have to match the ```host``` in the ```rules``` section .. this how the ingress controller knows which certificate to use for which host

Apply this configuration with
```
    kubectl apply -f azure-vote-https-ingress.yaml
```
and you get 
```
    ingress.networking.k8s.io/azure-vote-front-ingress configured
```

Now, our test application can be reached at ```https://aks-testcluster-westeurope.cloadapp.azure.com```, but still the certificate is not trusted, as we did issue it ourselves:
![configure public IP address with DNS name](test-application-with-own-certificate.png)





## Setting up TLS ingress with Credential Manager {#setup-tls-ingress-cred-manager}

TODO TODO TODO


TODO TODO TODO
In order that the certificates remain valid, they need to be taken care of and renewed before they expire. To achieve this, we will use the Credential Manager and certificates issued by Let's Encrypt!. 

However, you could set this all up using another PKI with issues your own certificates .. but this another case. The steps to be taken are similar, the configuration might differ in some parts and will differ in the values configured. For more information, head over to https://docs.microsoft.com/en-us/azure/aks/ingress-own-tls.

TODO
- how to intall Credential Manager?
- how to configre renewal for Certs?
- see 




Return to the main article [Azure Kubernetes](../README.md#remove-resources) and [remove all the resources from this example](../5-remove-resources/README.md).

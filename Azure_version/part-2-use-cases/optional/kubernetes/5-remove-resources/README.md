# Azure Kubernetes - Remove resources

>Documentation on the experiments carried out during the LabWeek 2022 on the AWK Cloud Lab

>Main contact: Werner Baumann (werner.baumann@awk.ch)

> go back to [Azure Kubernetes](../README.md)

## Remove resources
Before you call it a day, be sure to remove all the resources created from Azure, as they are incurring costs and need not be there any longer. You can always re-create all the resources by simply creating a new cluster and redeploying the configuration.

### Remove Ingress Controller
Depending on how you installed the Ingress Controller, either run
```
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.1.0/deploy/static/provider/cloud/deploy.yaml
```

or remove it by calling
```
    helm uninstall nginx-ingress
```

### Remove Application
To remove our application from the AKS cluster, simply call
```
    kubectl delete -f azure-vote.yaml
```

### Remove AKS cluster
As a last step, delete the AKS cluster from your subscription. Actually, this would indeed also remove all the applications on it, incluing the ingress controller and, if present, the Azure Kubernetes Registry (used for Helm).

```
    az aks delete --resource-group <your-resource-group> --name <your-cluster-name>
```

Return to the main article [Azure Kubernetes](../README.md), that was it.

# Azure Kubernetes - Setup cluster

>Documentation on the experiments carried out during the LabWeek 2022 on the AWK Cloud Lab

>Main contact: Werner Baumann (werner.baumann@awk.ch)

> go back to [Azure Kubernetes](../README.md)

## Setup of the AKS cluster
>❗In the Azure portal, make sure you have a subscription that has enough permission to setup an AKS cluster. Learning sandboxes might not. ;-)

### Setting up the AKS cluster with the Azure portal
- Go to Azure portal
- click "Create a resource", search for "AKS" and select "Kubernetes Service"
    - assign Subsciption and Resource group
    - select "Dev/Test ($)" as the cluster preset configuration
    - enter a cluster name (e.g. aks-testcluster)
    - select region (West Europe)
    - select Kubernetes version (or leave as default)
- click "Review + create" (for the test cluster, all other settings are OK .. but **not** for productive use!!)
    - the review might fail, as in the default setup for "Dev/Test ($)", a minimum of 12 vCPUs is used (4 per node). If so, follow the instructions to up your quota. Once the request is granted, you can retry.
    - or you resize your deployment to 2 nodes only (which needs 8 vCPUs and is therefore below the current quota of 10 vCPUs)
- wait until Deployment is done, then visit the resource in the Azure Portal

### Use CLI to access AKS cluster
If you want to work with your AKS cluster on a command line base, you must either 
- setup the *Azure CLI* as described in the main article [Azure Kubernetes](../README.md#setup-tools)

or
- use the Cloud Shell on the Azure portal

In the Auzure portal, you find the necessary instructions to connect your local CLI environment with the cluster as follows:
- go to the resource in the Azure portal
- click "Overview" in the left hand navigation
- click "Connect" in the ribbon navigation above the resource
- instructions on how to connect open on the right hand side of the window

Let's check this out
- list all nodes in our freshly installed cluster
```
    kubectl get nodes
```
should result in something similar to
```
    NAME                                STATUS   ROLES   AGE     VERSION
    aks-agentpool-25966145-vmss000000   Ready    agent   3h20m   v1.22.4
    aks-agentpool-25966145-vmss000001   Ready    agent   3h20m   v1.22.4
    aks-agentpool-25966145-vmss000002   Ready    agent   3m58s   v1.22.4
```

- list all the deployments on our freshly installed cluster
```
    # List all deployments in all namespaces
    kubectl get deployments --all-namespaces=true
```
should result in something similar to
```
    NAMESPACE     NAME                 READY   UP-TO-DATE   AVAILABLE   AGE
    kube-system   coredns              2/2     2            2           37m
    kube-system   coredns-autoscaler   1/1     1            1           37m
    kube-system   metrics-server       1/1     1            1           37m
    kube-system   tunnelfront          1/1     1            1           37m
```

Let's go back to the main article [Azure Kubernetes](../README.md##deploy-first-application) and [deploy a first application](../2-deploy-first-application/README.md).


### Setting up the AKS with CLI and templates
You can not only setup an AKS cluster in the Azure portal, but also by the Azure CLI. To create your basic AKS for testing, use 
```
    az aks create --resource-group rg-euwe-dev-labweek22-darkclouds --name myAKSCluster --node-count 1  --generate-ssh-keys
```
and, after some time to setup, you will end up with an AKS cluster which has one node.

For more information on what possibilites you have to manage your AKS cluster by CLI, see
```
    az aks --help
```
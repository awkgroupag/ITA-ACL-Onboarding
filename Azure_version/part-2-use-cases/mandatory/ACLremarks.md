# ACL Remarks from part 1

> ❗ACL Remark: Inside ACL, we follow a naming concept for resources.
> It can be found [here](/TODO.md).
> All resource names should follow a certain pattern *loga-example-purpose*, where the name should start with a 3-4 letter acronym of the resource type followed by the purpose of the resource.

> ❗ACL Remark: Inside ACL, we follow a tagging concept for resources.
> It can be found [here](/TODO.md).
> All resource resources must have an *owner* (email of the owner) and an *environment* (*prod* for production, *dev* for development) tag.

> ❗ACL Remark: Inside ACL, we put resource locks on every resource that serves a productive workload.

> ❗ACL Remark: Inside ACL, we follow a naming concept for resource groups.
> It can be found [here](/TODO.md).
> All resource group names should follow a certain pattern *rg-euwe-pr-example-purpose*, where the name should start with *rg* followed by the Azure region (see below), a tag for the environment (pr: production, dev: development) and the purpose.

> ❗ACL Remark: Inside ACL we mostly use *West Europe* or *North Europe* as Azure region.

# ACL Remarks from part 2

> ❗ACL Remark: Best practice is to create a GitHub repository to version the code.

> ❗ACL Remark: For a business critical application or for collaboration you should consider setting up a CI/CD-pipeline for your Azure function (see further knowledge). We are currently working on templates for CI/CD-pipeline for Azure functions.

> ❗ACL Remark: In most cases, the consumption plan for Azure Functions will fulfill your needs inside ACL.

> ❗ACL Remark: We are currently working on the standards of securing Azure functions inside ACL. For now:
>
> * Minimize the access (e.g. restrict CORS, require authentication/authorization)
> * Do not store secrets inside the code (Use Key Vault)
> * Require HTTPS
> * Monitor your function

Back to [overview page](../../main.md)

# Part 2: Introduction to Use Cases (Title TODO) <!-- omit in toc -->

> ⏱Estimated time: 6-8 hours

## What you will achieve in this part <!-- omit in toc -->

* Development environment is ready to use
* Try out resource deployments of use cases most commonly used inside ACL
* Make decisions about sizing, scaling and type of ressource
* Know where to look for further knowledge and whom to ask

## Learning Path <!-- omit in toc -->

- [Preparations](#preparations)
  - [Basic GitHub Knowledge](#basic-github-knowledge)
  - [Setup development environment](#setup-development-environment)
- [Mandatory Services](#mandatory-services)
- [Optional Services](#optional-services)

## Preparations

### Basic GitHub Knowledge

Do you have experience in modern version control for code? Do you know what git repository, commit, branch, merge request and issue are?

* Yes  --> Skip this section.
* No --> Check this [course](https://lab.github.com/githubtraining/introduction-to-github) out.
* I am not sure --> The above course takes less than 1 hour

### Setup development environment

As with every other coding projects, you may have already done, you first need to setup your development environment.
We recommend you to setup at least:

* A version control linked to our GitHub enterprise
* Access to your Azure Account
* An IDE (Integrated development environment) for handling deep code

We recommend that you choose Visual Studio Code (vscode, VSC) as it's the ACL default and we can provide support if needed.
You can use different platforms to setup your development environment:

* locally on you AWK Laptop
* remotely on a jump-host Azure VM
* online development with [vscode online](https://vscode.dev/)

You can choose the option that you prefer. In any case you need to do the following steps:

1. Install Git
   1. Get a new AWK-GitHub-Account or connect your GitHub-Account to AWK. To do so contact [Lukas Möller](mailto:lukas.moeller@awk.ch) or Jesko Mueller.
   2. There are several tools to handle Git locally on your Computer. If you are unexperienced a GUI might help in the beginning. E. g. [GitHub Desktop](https://desktop.github.com/)
   3. Install the desktop client and connect your GitHub-Account
2. Create your AWK Azure Account (you might have already done this during part 1)
   1. Go to the [Azure Portal](https://portal.azure.com)
   2. Choose "Login options" (EN) or "Anmeldeoptionen" (DE)
   3. Choose "" (EN) or "Bei einer Organisation anmelden" (DE)
   4. Insert "awk.ch" as domain and proceed
   5. Use SSO or sign in with your AWK Microsoft account
3. Install an IDE
   1. There are a several IDEs (Visual Studio, Visual Studio Code, Eclipse, IntelliJ IDEA, ...). We recommend Visual Studio Code (VSC). We chose it as our default IDE as it comes with a lot of Azure extensions and is available in a Community Edition. You are free to use your favorite IDE, but we cannot guarantee that we are able to help you when problems occur.
   2. Download the installer from [here](https://code.visualstudio.com/) and install the desktop client.
   3. Open VSC and install extensions that you need. We suggest the following:
      * [Azure Functions](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-azurefunctions)
      * A Linter of your choice
      * Everything necessary for the language you want to develop
   4. Connect your Azure Account inside VSC

> 💡Tip: Change your language to "English" and regional format to "English (United States)".
> This way error notes and looking for help in the internet is much easier.

Congrats your development environment is now set up, so that we can start with the more fun part 😉

## Mandatory Services

We find the following services either important in a general cloud computing context or essential to contribute in the ACL.
Have a look into all of these topics:

* [Azure Logic Apps](mandatory/logic-apps.md)
* [Azure Functions](mandatory/azure-function.md)
* [Networking (Virtual Networks) ⚠ Not ready](mandatory/networking.md)
* [Azure Key Vault ❌ TODO](/TODO.md)
* [Container hosting options ❌ TODO](mandatory/container.md)

## Optional Services

There are too many services available in Azure to know them all in depth.
The following list represents services and topics that might be of situational relevance to you.
Choose 1-3 of the topics that interests you the most:

* [Azure Web App](optional/web-app.md) (Advanced)
* [Azure Tenant Governance ⚠ Not ready](optional/tenant-governance.md) (Expert)
* [Azure Database options ⚠ Not ready](optional/databases.md) (Advanced)
* [Kubernetes❌ TODO](/TODO.md) (Advanced)
* [Advanced Policies ❌ TODO](/TODO.md) (Medium)
* [Advanced Alerts ❌ TODO](/TODO.md) (Medium)
* [Advanced Storage ❌ TODO](/TODO.md) (Medium)
* [Power Platform Tutorial](optional/power-platform.md) (Beginner)
* (to challenge) [Azure Security Baselines ⚠ Not ready](optional/security-baselines.md) (Expert)
* (to challenge) [Machine Learning with Azure ⚠ Not ready](optional/machine-learning.md) (Advanced)

We tried to give a complexity rating and an estimate of the time needed.
Of course you can also have a look into all of those topics.

## Finish <!-- omit in toc -->

Next part: [Part 3: Get to know the ACL application landscape](../part-3-awk-applications/main.md)

Back to [Part 1: First steps in Azure](../part-1-sandbox/main.md)

Back to [overview page](../main.md)

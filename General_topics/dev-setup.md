# Dev Setup

There are several ways to setup your dev environment. Some elements are necessary, some are optional or have alternatives:

- basics toolset
  - distributed version control system for source code - [Git](#git)
  - major provider for Git - [GitHub](#github)
  - source-code editor / IDE - [VS Code](#VS-code)
  - Windows Subsystem for Linux - [WSL](#wsl)
- dev environment (alternatives)
  - [containers](#containers)
  - [VMs](#vms)

In case you find problems with the resources below, or have hints, fixes, etc. please send us a message, commit or post an issue.

---

## Basic Toolset

### Git

Do you have experience in modern version control for code? Do you know what git repository, commit, branch, merge request and issue are? If no, check out [this course](https://lab.github.com/githubtraining/introduction-to-github) (less than 1 hour).

As a first step, you'll need to install Git.

- [Git for Windows](https://git-scm.com/download/win)
- [Git for Linux](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

There are several clients to handle Git. You can:

- use the [GitHub Desktop](https://desktop.github.com/) client (for beginners)
- use the [GitKraken](https://www.gitkraken.com/git-client) client (for intermediate users)
- use Git with the command line (for experts)

### Github

The AWK GitHub, [awkgroupag](https://github.com/awkgroupag) is managed by the DI&C and the DA&AI team. You'll find an intro on how to get onboarded [here](../Azure_version/part-2-use-cases/main.md).

### VS Code

You can use the development environment of your choice. However, we recommend that you use Visual Studio Code (vscode, VSC) as it's the ACL default and we can provide support if needed. You can use different platforms to setup your development environment:

- [VS Code](https://code.visualstudio.com/download) locally on you AWK Laptop
- remotely on a jump-host Azure VM (see [VMs](#vms) below)
- online development with [vscode.dev](https://vscode.dev/)

---

## Dev Environments

### WSL

> Windows Subsystem for Linux is a compatibility layer for running Linux binary executables natively on Windows 10, Windows 11, and Windows Server 2019. - [WSL, Wikipedia](https://en.wikipedia.org/wiki/Windows_Subsystem_for_Linux)

Follow [these instructions](https://www.windowscentral.com/install-windows-subsystem-linux-windows-10) to install WSL on Windows 10.

You'll find the official WSL FAQ [here](https://docs.microsoft.com/en-us/windows/wsl/faq). And an extensive guide [here](https://adamtheautomator.com/windows-subsystem-for-linux/)

In case you have connectivity issues try disconnecting from the internal WiFi and / or disabling the VPN. Reset the network config as in [here](https://stackoverflow.com/a/64545668/3188654). Related GitHub issues [here](https://github.com/microsoft/WSL/issues/4275) and [here](https://github.com/microsoft/WSL/issues/5068). Other commen troubleshooting issues [here](https://docs.microsoft.com/en-us/windows/wsl/troubleshooting).

#### Command line tools

There are hundreds of command line tools. Here are just some examples:

- [Windows Terminal](https://www.microsoft.com/en-us/p/windows-terminal/9n0dx20hk701) (simple, recommended)
- VS Code built-in terminal (see above)
- [MobaXterm](https://mobaxterm.mobatek.net/) for Windows (more complete, less pretty and more advanced)

### Containers

The most common tool for managing and running containers is Docker. Docker is open-source, but running it on Windows requires Docker Desktop, which is not free for organisation over 250 employees.

> **_Note on Docker:_** We decided to move away from Docker and recommend you do the same; c.f. [here](https://people.redhat.com/abach/OSAW/FILES/DAY1/5%20Moving%20on%20from%20Docker.pdf) and [here](https://martinheinz.dev/blog/35).

If you need an intro on alternatives, see the last link above. Otherwise, just follow our picks below.

#### Podman

You can install [podman](https://podman.io/) (and use it exactly like you would docker) as follows (reference [here](https://www.how2shout.com/linux/how-to-install-podman-on-ubuntu-20-04-wsl2/)). Assuming you're on Ubuntu 20.04 (check with `cat /etc/os-release`).

Add repository:

    # ignore if you're on Ubuntu 20.10 or later
    echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/xUbuntu_20.04/ /" |
    sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list

Add GPG key:

    # ignore if you're on Ubuntu 20.10 or later
    curl -L "https://download.opensuse.org/repositories/devel:/kubic:\
    /libcontainers:/stable/xUbuntu_20.04/Release.key" | sudo apt-key add -

Update & upgrade packages and install podman:

    sudo apt update
    sudo apt -y upgrade
    sudo apt -y install podman

Check the installation with `podman --version`.

Note: if you get a warning again and again while pulling the images: *WARN[0000] “/” is not a shared mount, this could cause issues or missing mounts with rootless containers*, run these commands:

    sudo chmod 4755 /usr/bin/newgidmap
    sudo chmod 4755 /usr/bin/newuidmap

#### Rancher Desktop

If you want to manage your containers or Kubernetes with a desktop application, you can use [Rancher Desktop](https://rancherdesktop.io/). This will provide a small scale Kubernetes equivalent on your desktop for development.

### Lab: Install k3s (Lightweight Kubernetes)
Event though the [Lab: Install k3s cluster on VMs in Azure und AWS](./k3s_Azure_AWS/README.md) uses VMs on Azure and AWS, you can use the instructions in this Lab to install k3s on your local desktop.


### VMs

[Content will come later. Feel free to help!]

# Workshop Setup

You'll need to follow the steps below to setup your machine for the workshop.

## Steps

* [1. Get a Docker ID](#1)
* [2. Get Docker](#2)
* [3. Pull the Windows base images](#3)
* [4. Tool up!](#4)
* [5. Get the source](#5)
* [6. Test your setup](#6)


## <a name="1"></a>Step 1: Get a Docker ID

You will build images and push them to Docker Hub during the workshop, so they are available to use later. You'll need a Docker ID to push images.

- Sign up for a free Docker ID on [Docker Cloud](https://cloud.docker.com/)

## <a name="2"></a>Step 2. Get Docker

We are using new features in Docker 17.05. For the workshp we will provide you with a VM running in Azure which is already configured with everything you need. 

If you want to use your own laptop or a VM running Windows 10 or Windows Server 2016, you'll need to install Docker 17.05, and follow the rest of the steps in this page to get your environment set up.

### Azure VM

You are welcome to use one of our hosted VMs on Microsoft's Azure cloud. This is a Windows Server 2016 VM with Docker EE already installed. Sign up at the [registration page]() and you will be emailed a link with connection details.

> Your Azure VM will be destoyed after the workshop, so your work will be lost - but the images you push to Docker Hub will still be available.

You do not need Docker running on your laptop for this option, but you will need a Remote Desktop client to connect to the VM. 

- Windows - use the built-in Remote Desktop Connection app.
- Mac - install [Microsoft Remote Desktop](https://itunes.apple.com/us/app/microsoft-remote-desktop/id715768417?mt=12) from the app store.
- Linux - install [Remmina](http://www.remmina.org/wp/), or any RDP client you prefer.

Once you've connected to your Azure VM, skip to [Step 5](#5).

### OR - Windows 10

Install [Docker CE for Windows]() from Docker Store, making sure to choose the Edge build to get the latest version. Run Docker for Windows and from the taskbar switch to Windows containers:

![img]()

### OR - Windows Server 2016

Install [Docker EE for Windows Server]() from Docker Store. The installation deploys Docker as a Windows service and starts the service for you. Then you need to replace the EE version with 17.05 CE:

>TODO


## <a name="3"></a>Step 3. Pull the Windows base images

We will use Docker images based on Windows Server Core and Nano Server, so be sure you have these image versions available.

```
docker pull microsoft/nanoserver:10.0.14393.693
docker pull microsoft/windowsservercore:10.0.14393.693
```

And tag them as `latest` in case you have any older versions of the image:

```
docker tag microsoft/nanoserver:10.0.14393.693 microsoft/nanoserver:latest
docker tag microsoft/windowsservercore:10.0.14393.693 microsoft/windowsservercore:latest
```

Now pull a couple of other big images, which will save time later:

```
docker pull microsoft/mssql-server-windows-express
docker pull sixeyed/msbuild:4.5.2-webdeploy
```

## <a name="4"></a>Step 4. Tool up!

Also you'll need some tools - Git to pull the workshop repo, and a text editor. Visual Studio isn't required for this workshop.

The PowerShell Git module and Visual Studio code are nice options. You can install them with [Chocolatey]():

```
choco install poshgit
choco install vscode
```

> If you're using one of the lab VMs, these tools are already installed.


## <a name="5"></a>Step 5. Get the source

Source code for the workshop is on a public GitHub repo. The lab VM has the repo set up, so just pull to make sure the latest changes are downloaded:

```
cd C:\scm\github\sixeyed\dc-mta-workshop
git pull
```

If you're using your own machine, you can clone the repo wherever you like, but the instructions assume a known directory structure. You can setup your environment to match with:

```
mkdir -p C:\scm\github\sixeyed
cd C:\scm\github\sixeyed
git clone https://github.com/sixeyed/dc-mta-workshop
```

## <a name="6"></a>Step 6. Test your setup

Open a PowerShell prompt **using Run as Administrator** and run the verification script:

```
cd C:\scm\github\sixeyed\dc-mta-workshop
.\verify.ps1 $DockerID
```

You should see a useful message, proving your Docker setup is working correctly.

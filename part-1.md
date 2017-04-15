# Part 1 - Docker on Windows

We'll start with the basics and get a feel for running Docker on Windows.

If you've previously used Docker, it's still worth following along. This workshop uses the new expanded Docker CLI syntax (like `docker container ls` rather than `docker ps`), so it will introduce you to the new commands.

## Steps

* [1. Run some simple Windows Docker containers](#1)
 * [1.1. Run a task in a Nano Server container](#1.1)
 * [1.2. Run an interactive Windows Server Core container](#1.2)
 * [1.3. Run a background IIS web server container](#1.3)
* [2. Package and run a custom app using Docker](#2)
 * [2.1: Build a custom website image](#2.1)
 * [2.2: Push your image to Docker Hub](#2.2)
 * [2.3: Run your website in a container](#2.3)

## <a name="1"></a>Step 1. Run some simple Windows Docker containers

There are different ways to use containers:

1. In the background for long-running services like websites and databases
2. Interactively for connecting to the container like a remote server
3. To run a single task, which could be a PowerShell script or a custom app

In this section you'll try each of those options and see how Docker manages the workload.

## <a name="1.1"></a>Step 1.1: Run a task in a Nano Server container

This is the simplest kind of container to start with. In PowerShell run:

```
docker container run microsoft/nanoserver hostname
```

You'll see the output written from the `hostname` command.

Docker keeps a container running as long as the process it started inside the container is still running. In this case the `hostname` process completes when the output is written, so the container stops. The Docker platform doesn't delete resources by default, so the container still exists. 

List all containers and you'll see your Nano Server container in the `Exited` state:

```
> docker container ls --all
CONTAINER ID        IMAGE                  COMMAND             CREATED             STATUS                     PORTS               NAMES
18876defb3d6        microsoft/nanoserver   "hostname"          7 seconds ago       Exited (0) 5 seconds ago
```

> Note that the container ID *is* the hostname that the container wrote out

Containers which do one task and then exit can be very useful. You could build a Docker image which installs the Azure PowerShell module and bundles a set of scripts to create a cloud deployment. Anyone can execute that task just by running the container - they don't need the scripts or the right version of the Azure module, they just need to pull the Docker image.


## <a name="1.2"></a>Step 1.2: Run an interactive Windows Server Core container

The [microsoft/windowsservercore](https://hub.docker.com/r/microsoft/windowsservercore) image is a full Windows Server 2016 OS, without the UI. You can explore an image by running an interactive container. 

Run this to start a Windows Server Core container and connect to it:

```
docker container run --interactive --tty --rm microsoft/windowsservercore powershell
```

When the container starts you'll drop into a PowerShell session with the default prompt `PS C:\>`. Docker has attached to the console in the container, relaying input and output between your PowerShell window and the PowerShell session in the container.

Run some commands to see how the Windows Server Core image is built:

- `ls c:\` - lists the C drive contents, you'll see this is a minimal installation of Windows 
- `Get-Process` - shows all running processes in the container. There are a number of Windows Services, and the PowerShell exe
- `Get-WindowsFeature` - shows the Windows feature which are available or already installed

Now run `exit` to leave the PowerShell session, which stops the container process. Using the `--rm` flag means Docker now removes that container.

Interactive containers are useful when you are putting together your own image. You can run a container and verify all the steps you need to deploy your app, and capture them in a Dockerfile. 

> You *can* [commit](https://docs.docker.com/engine/reference/commandline/commit/) a running container to make an image - but you must promise to never, ever do that. It's much better to have a repeatable [Dockerfile](https://docs.docker.com/engine/reference/builder/). You'll do that in a later task.

## <a name="task1.3"></a>Run a background SQL Server container

Background containers are how you'll run your application. Here's a simple exmaple using another image from Microsoft - [microsoft/mssql-server-windows-express](https://hub.docker.com/r/microsoft/mssql-server-windows-express/) which builds on top of the Windows Server Core image and comes with SQL Server Esxpress installed.

Run it in the background as a detached container:

```
docker container run --detach --name sql `
 --env ACCEPT_EULA=Y `
 --env sa_password=DockerCon!!! `
 microsoft/mssql-server-windows-express
```

> If you don't have this image, Docker will pull it when you first run a container. 

As long as the SQL Server process keeps running, Docker will keep the container running in the background.

You can check what's happening by viewing the logs from the container, and seeing the process list:

```
docker container logs sql
docker container top sql
```

The SQL Server instance is isolated in a container, because no ports are published. Other containers can access it, and you can run commands inside the container through Docker.

Check what the time is in the database container:

```
docker container exec sql `
 powershell "Invoke-SqlCmd -Query 'SELECT GETDATE()' -Database Master"
```

Now clean up, by removing any running containers:

```
docker container rm --force $(docker container ls --quiet)
```

## <a name="task2"></a>Step 2: Package and run a custom app using Docker

Next you'll learn how to package your own Windows app as a Docker image, using a [Dockerfile](https://docs.docker.com/engine/reference/builder/). 

The Dockerfile syntax is simple. In this task you'll walk through a Dockerfile for a custom website, and see how to package and run it with Docker.

Have a look at the [Dockerfile for the lab](tweet-app/Dockerfile), which builds a simple static website running on IIS. These are the main features:

- it is based [FROM](https://docs.docker.com/engine/reference/builder/#from) `microsoft/windowsservercore`, so the image will start with a clean Windows Server 2016 deployment
- it uses the [SHELL](https://docs.docker.com/engine/reference/builder/#shell) instruction to switch to PowerShell when building the Dockerfile, so the commands to run are all in PowerShell
- it adds the IIS Windows feature and exposes port 80, setting up the web server and allowing traffic into containers on port 80
- it configures IIS to write all log output to a single file, using the `Set-WebConfigurationProperty` cmdlet
- it copies the [start.ps1](tweet-app/start.ps1) startup script and [index.html](tweet-app/index.html) files from the host into the image
- it specifies `start.ps1` as the [CMD](https://docs.docker.com/engine/reference/builder/#cmd) to run when containers start. The script starts the IIS Windows Service and relays the log file entries to the console
- it adds a [HEALTHCHECK](https://docs.docker.com/engine/reference/builder/#healthcheck) which makes an HTTP GET request to the site and returns whether it got a 200 response code


## <a name="task2.1"></a>Step 2.1: Build the custom website image

To build the Dockerfile, change to the `tweet-app` directory and run the `build` command:

```
cd C:\scm\github\sixeyed\dc-mta-workshop\part-1\tweet-app
docker image build --tag $DockerID/mta-tweet-app .
```
> Be sure to use your Docker ID in the image tag. You will share it on Docker Hub in the next step, and you can only do that if you use your ID. My Docker ID is `sixeyed`, so I run `docker build -t sixeyed/dockercon-tweet-app` 

You'll see output on the screen as Docker runs each instruction in the Dockerfile.

The build command will take a little while to run, as the step to install IIS takes a while in Windows. Once it's built you'll see a `Successfully built...` message. If you repeat the `docker build` command again, it will complete in seconds. That's because Docker caches the [image layers](https://docs.docker.com/engine/userguide/storagedriver/imagesandcontainers/) and only runs instructions if the Dockerfile has changed since the cached version.

Now if you list the images and filter on the `mta` name, you'll see your new image:

```
> docker image ls -f reference=*/mta*

REPOSITORY                    TAG                 IMAGE ID            CREATED             SIZE
sixeyed/dockercon-tweet-app   latest              a14860778046        11 minutes ago      10.4 GB
```

Docker has built the image but it's only stored on the local machine. Next we'll push it to a public repository.

## <a name="task2.2"></a>Task 2.2: Push your image to Docker Hub

Distribution is built into the Docker platform. You can build images locally and push them to a [registry](https://docs.docker.com/registry/), making them available to other users. Anyone with access can pull that image and run a container from it. The behavior of the app in the container will be the same for everyone, because the image contains the fully-configured app - the only requirements to run it are Windows and Docker.

[Docker Hub](https://hub.docker.com) is the public registry for Docker images. To push images, you need to log in using the command line and providing your Docker ID credentials:

```
> docker login
Login with your Docker ID to push and pull images from Docker Hub. If you don't have a Docker ID, head over to https://hub.docker.com to create one.
Username: <DockerID>
Password:
Login Succeeded
```

Now upload your image to the Hub:

```
docker push $DockerID/mta-tweet-app
```

You'll see the upload progress for each layer in the Docker image. The IIS layer is almost 300MB so that will take a few seconds. The whole image is over 10GB, but the bulk of that is in the Windows Server Core base image. Those layers are already stored in Docker Hub, so they don't get uploaded - only the new parts of the image get pushed.

You can browse to *https://hub.docker.com/r/$DockerID/mta-tweet-app/* and see your newly-pushed app image. This is a public repository, so anyone can pull the image - you don't even need a Docker ID to pull public images.

## <a name="task2.3"></a>Task 2.3: Run your website in a container

It's time to run your app and see what it does! 

This is a web application, so you'll run it in the background and publish the HTTP port so traffic from the host is redirected into the container:

```
docker container run --detach --publish 80:80 --name app $DockerID/mta-tweet-app 
```

If you're running on a VM, browse to the VM address from your laptop browser and you'll see the web app. If you're running locally, you need to browse to the container's IP address. Find it with:

```
docker container inspect app --format '{{ .NetworkSettings.Networks.nat.IPAddress }}'
```

You should see this:

![The DockerCon Tweet app in a Windows Server Core container](images/tweet-app.png)

Go ahead and hit the button to Tweet about the workshop! No data gets stored in the container, so your credentials are safe. 

## Wrap Up

That's it for Part 1. Next we'll get stuck into modernizing ASP.NET apps.

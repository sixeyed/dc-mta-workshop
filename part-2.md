# Part 2 - Modernizing .NET Apps, for Ops

In this section we have an existing app, already packaged as an MSI. We'll Dockerize a few versions of the app, seeing how to do service updates and the benefits of Dockerfiles over MSIs.

## Steps

* [1. Package an ASP.NET MSI as a Docker image](#1)
* [2. Update the ASP.NET site with a new image version](#2)
* [3. Use Docker to build the source and package without an MSI](#3)

## <a name="1"></a>Step 1. Package an ASP.NET MSI as a Docker image

It's easy to package an MSI into a Docker image - use `COPY` to copy the MSI into the image, and `RUN` to install the application using `msiexec`, which is already bundled in the Windows base image.

Version 1.0 of our demo app is ready to go - check out the [Dockerfile](part-2/v1.0/Dockerfile). 

Packaging the app with Docker is the same `build` command - you'll use an image tag to identify the version:

```
cd C:\scm\github\sixeyed\dc-mta-workshop\part-2\v1.0
docker image build --tag $DockerID/mta-app:1.0 .
```

The app uses SQL Server, but rather than start individual containers, you'll use [Docker Compose]() to organize the solution.

```
cd ..
docker-compose -f docker-compose-1.0.yml up -d
```

And register your details - that will write a row to SQL Server. The SQL Server container is only available to other Docker containers because no ports are published. You can execute PowerShell in the container to see your data:

```
docker exec part2_mta-db_1 powershell "Invoke-SqlCmd -Query 'SELECT * FROM Prospects' -Database ProductLaunch"
```

Version 1.0 has a pretty basic UI. Next you'll upgrade to a fancier version.

## <a name="2"></a>Step 2. Update the ASP.NET site with a new image version

For the new app version there's a new MSI. The [Dockerfile](part-2/v1.1/Dockerfile) is exatly the same as v1.0, just using a different MSI. This scenario is where you have a new application 


```
cd C:\scm\github\sixeyed\dc-mta-workshop\part-2\v1.1
docker image build --tag $DockerID/mta-app:1.1 .
```
xx

```
cd ..
docker-compose -f docker-compose-1.1.yml up -d
```

xx

```
C:\scm\github\sixeyed\dc-mta-workshop

docker build -t $DockerID/mta-app:1.2 -f part-2\v1.2\Dockerfile .
```

xx

```
docker exec part2_mta-db_1 powershell "Invoke-SqlCmd -Query 'SELECT * FROM Prospects' -Database ProductLaunch"
```

xx

```
cd C:\scm\github\sixeyed\dc-mta-workshop\part-2

docker-compose -f docker-compose-1.2.yml up -d
```

```
docker exec part2_mta-db_1 powershell "Invoke-SqlCmd -Query 'SELECT * FROM Prospects' -Database ProductLaunch"
```

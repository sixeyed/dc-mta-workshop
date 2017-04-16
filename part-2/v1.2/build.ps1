
[CmdletBinding()]
Param(
   [Parameter(Mandatory=$True,Position=1)]
   [string] $dockerID
)

docker build `
 -t $dockerID/mta-builder `
 $pwd\docker\builder

docker run --rm `
 -v $pwd\..\..\src\ProductLaunch:c:\src `
 -v $pwd\docker:c:\out `
 $dockerID/mta-builder `
 C:\src\build.ps1 

Remove-Item -Recurse -Force $pwd\docker\web\ProductLaunch.Web
Move-Item -Force $pwd\docker\web\ProductLaunchWeb\_PublishedWebsites\ProductLaunch.Web $pwd\docker\web
Remove-Item -Recurse -Force $pwd\docker\web\ProductLaunchWeb

docker build `
 -t $dockerID/mta-app:1.2 `
$pwd\docker\web
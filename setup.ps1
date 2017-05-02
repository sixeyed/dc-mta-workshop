# run Windows Update

# TODO - you will need to do this manually with `sconfig`, if the update needs a reboot

#Install-Module PSWindowsUpdate -Force
#Import-Module PSWindowsUpdate
#Get-WUInstall -AcceptAll -IgnoreReboot | Out-File C:\PSWindowsUpdate.log

# update Docker

Stop-Service docker
$version = "17.05.0-ce-rc1"

$wc = New-Object net.webclient
$wc.DownloadFile("https://test.docker.com/builds/Windows/x86_64/docker-$version.zip", "$env:TEMP\docker.zip")
Expand-Archive -Path "$env:TEMP\docker.zip" -DestinationPath $env:ProgramFiles -Force
Remove-Item "$env:TEMP\docker.zip"

Start-Service docker

# Docker compose

$composeVersion = "1.12.0"
$wc = New-Object net.webclient
$wc.DownloadFile("https://github.com/docker/compose/releases/download/$composeVersion/docker-compose-Windows-x86_64.exe", "$env:ProgramFiles\Docker\docker-compose.exe")

# update base images

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://raw.githubusercontent.com/sixeyed/devtest-lab-ddc/master/scripts/windows/pull-base-images.ps1'))

# install Chocolatey & tools

Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))
choco install -y poshgit
choco install -y visualstudiocode
choco install -y firefox

# configure Server Manager 
New-ItemProperty -Path HKCU:\Software\Microsoft\ServerManager -Name DoNotOpenServerManagerAtLogon -PropertyType DWORD -Value "1" -Force

# TODO - bginfo

# pull lab images
docker pull microsoft/iis:windowsservercore
docker pull microsoft/aspnet:windowsservercore
docker pull sixeyed/msbuild:4.5.2-webdeploy
docker pull microsoft/mssql-server-windows-express
docker pull microsoft/aspnet:windowsservercore-10.0.14393.693
docker pull microsoft/aspnet:windowsservercore-10.0.14393.1066
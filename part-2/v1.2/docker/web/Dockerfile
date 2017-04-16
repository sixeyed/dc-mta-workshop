# escape=`
FROM microsoft/aspnet:windowsservercore-10.0.14393.693
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord
ENV DB_CONNECTION_STRING="Server=sql;Database=ProductLaunch;User Id=sa;Password=DockerCon!!!"

RUN New-Item -Path 'C:\web-app' -Type Directory; `
    New-WebApplication -Name ProductLaunch -Site 'Default Web Site' -PhysicalPath 'C:\web-app'

HEALTHCHECK CMD powershell -command `
    try { `
     $response = iwr http://localhost/ProductLaunch -UseBasicParsing; `
     if ($response.StatusCode -eq 200) { return 0} `
     else {return 1}; `
    } catch { return 1 }

COPY ProductLaunch.Web /web-app
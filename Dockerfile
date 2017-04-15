# escape=`
FROM microsoft/aspnet:windowsservercore-10.0.14393.1066
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

# disable DNS cache so container addresses always fetched from Docker
RUN Set-ItemProperty -path 'HKLM:\SYSTEM\CurrentControlSet\Services\Dnscache\Parameters' -Name ServerPriorityTimeLimit -Value 0 -Type DWord

RUN Remove-Website 'Default Web Site';

RUN Enable-WindowsOptionalFeature -Online -FeatureName IIS-ApplicationDevelopment,IIS-ASPNET45,IIS-BasicAuthentication,IIS-ClientCertificateMappingAuthentication,IIS-CommonHttpFeatures,IIS-DefaultDocument,IIS-DigestAuthentication,IIS-DirectoryBrowsing,IIS-HealthAndDiagnostics,IIS-HttpCompressionDynamic,IIS-HttpCompressionStatic,IIS-HttpErrors,IIS-HttpLogging,IIS-HttpRedirect,IIS-IISCertificateMappingAuthentication,IIS-IPSecurity,IIS-ISAPIExtensions,IIS-ISAPIFilter,IIS-LoggingLibraries,IIS-NetFxExtensibility45,IIS-Performance,IIS-RequestFiltering,IIS-RequestMonitor,IIS-Security,IIS-StaticContent,IIS-URLAuthorization,IIS-WebServer,IIS-WebServerRole,IIS-WindowsAuthentication,NetFx4Extended-ASPNET45

# Set up website: atsea
RUN New-Item -Path 'C:\websites\Docker.AtSea.Api' -Type Directory -Force; 

RUN New-Website -Name 'atsea' -PhysicalPath 'C:\websites\Docker.AtSea.Api' -Port 8080 -Force; 

EXPOSE 8080

COPY ["Docker.AtSea.Api", "/websites/Docker.AtSea.Api"]

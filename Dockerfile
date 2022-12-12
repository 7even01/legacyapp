# escape=`
FROM mcr.microsoft.com/dotnet/framework/sdk:4.7.2 AS builder

# копіювання необхідних файлів для розпакування залежностей
WORKDIR C:\src
COPY *.sln .
COPY LegacyApp\LegacyApp.csproj .\LegacyApp\
RUN nuget restore

# копіювання решти файлів додатку і запуск збирання
COPY . C:\src
RUN msbuild LegacyApp\LegacyApp.csproj /p:OutDir=C:\dest /p:Configuration=Release

FROM mcr.microsoft.com/dotnet/framework/aspnet:4.7.2-windowsservercore-ltsc2019
SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop';"]

ENV APP_ROOT=C:\web-app

WORKDIR ${APP_ROOT}
RUN Remove-Website -Name 'Default Web Site';`
    New-Website -Name 'web-app' -Port 80 -PhysicalPath $env:APP_ROOT; `
    New-WebApplication -Name 'app' -Site 'web-app' -PhysicalPath $env:APP_ROOT

# копіювання зібраного додатку до фінального контейнеру
COPY --from=builder C:\dest\_PublishedWebsites\LegacyApp .
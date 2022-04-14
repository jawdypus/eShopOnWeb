FROM mcr.microsoft.com/dotnet/aspnet:6.0

EXPOSE 80
EXPOSE 443

WORKDIR /app
ADD  Publish .
ENTRYPOINT ["dotnet", "PublicApi.dll"]
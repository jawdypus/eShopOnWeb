FROM mcr.microsoft.com/dotnet/aspnet:6.0

EXPOSE 80
EXPOSE 443

WORKDIR /app
COPY ./bin/Publish/PublicApi/* ./
ENTRYPOINT ["dotnet", "PublicApi.dll"]
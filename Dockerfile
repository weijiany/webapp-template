FROM mcr.microsoft.com/dotnet/core/sdk:3.1 as builder
WORKDIR /app
COPY . .
RUN dotnet publish ./WebApp -c Release -o ./out

FROM mcr.microsoft.com/dotnet/core/aspnet:3.1
WORKDIR /app
COPY --from=builder /app/out .
ENTRYPOINT ["dotnet", "WebApp.dll"]

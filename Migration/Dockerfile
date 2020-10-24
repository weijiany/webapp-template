FROM mcr.microsoft.com/dotnet/core/sdk:2.2
ENV PATH="${PATH}:/root/.dotnet/tools"
WORKDIR /app
COPY . .
# -c --confugration refer to 'https://docs.microsoft.com/en-us/visualstudio/debugger/how-to-set-debug-and-release-configurations?view=vs-2019'
RUN dotnet tool install FluentMigrator.DotNet.Cli --version "3.2.9" -g \
    && dotnet publish -c Release -o ./out
ENTRYPOINT ["./entry-point.sh"]

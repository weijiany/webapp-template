- [ ] 1.use dotnet core cli to create project.

```bash
dotnet new sln # init an empty sloution
dotnet new web -o WebApp # init a web app project
dotnet new xunit -o WebApp.Test # init a xunit test project

dotnet sln webapp.sln add ./WebApp/WebApp.csproj ./WebApp.Test/WebApp.Test.csproj # add these prject to empty sloution
dotnet add ./WebApp.Test/WebApp.Test.csproj reference ./WebApp/WebApp.csproj # add reference to WebApp project

dotnet add package Microsoft.AspNetCore.TestHost --version 3.1.9 # install TestServer for testing
```

- [ ] 2.run dotnet core project in docker

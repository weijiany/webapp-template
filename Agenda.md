- [ ] use dotnet core cli to create project. and run dotnet core project in docker

```bash
dotnet new sln # init an empty sloution
dotnet new web -o WebApp # init a web app project
dotnet new xunit -o WebApp.Test # init a xunit test project

dotnet sln webapp.sln add ./WebApp/WebApp.csproj ./WebApp.Test/WebApp.Test.csproj # add these prject to empty sloution
dotnet add ./WebApp.Test/WebApp.Test.csproj reference ./WebApp/WebApp.csproj # add reference to WebApp project

dotnet add package Microsoft.AspNetCore.TestHost --version 3.1.9 # install TestServer for testing
```

- [ ] build sql server image and create an new database.
- [ ] run fluent migrator to migrate all sql migration, and use docker-compose to start db and migration container
- [ ] use terrafrom (v0.13.5) to create a resource group, sql server and sql database. and use git-crypt to encrypt azure sp account file
- [ ] use azure dev ops to run WebApp project test and sql migration.
- [ ] create azure container repository and add push docker image to acr
- [ ] create aks and deploy WebApp and k8s service.
- [ ] use helm to package deployment and service. deploy WebApp by helm
- [ ] create azure api management and publish WebApp api to it.
- [ ] copy a new environment.
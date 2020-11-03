using System;
using System.Collections.Generic;
using System.Net.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;

namespace WebApp.Test.ApiSpec
{
    public class SpecBase
    {
        protected readonly HttpClient _client;

        protected SpecBase()
        {
            var saPassword = Environment.GetEnvironmentVariable("SA_PASSWORD") ?? "WJY@123456";
            var databaseName = Environment.GetEnvironmentVariable("DATABASE_NAME") ?? "WebApp";
            var databaseServer = Environment.GetEnvironmentVariable("DATABASE_SERVER") ?? "localhost";

            var myConfiguration = new Dictionary<string, string>
            {
                ["DB:UserName"] = "sa",
                ["DB:Password"] = saPassword,
                ["DB:DataBase"] = databaseName,
                ["DB:Server"] = databaseServer
            };
            var configuration = new ConfigurationBuilder()
                .AddInMemoryCollection(myConfiguration)
                .Build();

            var hostBuilder = new WebHostBuilder().UseStartup<Startup>()
                .ConfigureAppConfiguration((_, builder) => builder.AddConfiguration(configuration));
            var testServer = new TestServer(hostBuilder);
            _client = testServer.CreateClient();
        }
    }
}
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
            var myConfiguration = new Dictionary<string, string>
            {
                ["DB:Server"] = "localhost",
                ["DB:UserName"] = "sa",
                ["DB:Password"] = "WJY@123456",
                ["DB:DataBase"] = "WebApp"
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
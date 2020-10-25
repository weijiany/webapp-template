using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Microsoft.Extensions.Configuration;
using Newtonsoft.Json;
using WebApp.Model;
using Xunit;

namespace WebApp.Test.ApiSpec
{
    public class PersonApiSpec
    {
        private readonly HttpClient _client;

        public PersonApiSpec()
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

        [Fact]
        async Task should_return_ok_when_get_person()
        {
            var httpRequestMessage = new HttpRequestMessage(HttpMethod.Get, "/persons");
            var response = await _client.SendAsync(httpRequestMessage);
            Assert.Equal(HttpStatusCode.OK, response.StatusCode);

            var responseBody = await response.Content.ReadAsStringAsync();
            var persons = JsonConvert.DeserializeObject<IList<Person>>(responseBody);
            Assert.Single(persons);
            Assert.Equal("Lucy", persons.Single().Name);
        }
    }
}
using System.Net.Http;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Xunit;

namespace WebApp.Test.ApiSpec
{
    public class HelloWorldApiSpec
    {
        private HttpClient _client;

        public HelloWorldApiSpec()
        {
            var testServer = new TestServer(new WebHostBuilder().UseStartup<Startup>());
            _client = testServer.CreateClient();
        }

        [Fact]
        void should_return
    }
}
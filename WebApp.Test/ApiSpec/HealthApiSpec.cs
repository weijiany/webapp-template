using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.TestHost;
using Xunit;

namespace WebApp.Test.ApiSpec
{
    public class HealthApiSpec : SpecBase
    {
        [Fact]
        async Task should_return_ok()
        {
            var httpRequestMessage = new HttpRequestMessage(HttpMethod.Get, "/health");
            var response = await _client.SendAsync(httpRequestMessage);
            var responseBody = await response.Content.ReadAsStringAsync();

            Assert.Equal("ok", responseBody);
        }
    }
}
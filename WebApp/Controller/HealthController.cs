using Microsoft.AspNetCore.Mvc;

namespace WebApp.Controller
{
    [Route("hello")]
    public class HelloWorldController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            return "Hello World!!!";
        }
    }
}
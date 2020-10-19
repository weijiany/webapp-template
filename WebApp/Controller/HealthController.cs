using Microsoft.AspNetCore.Mvc;

namespace WebApp.Controller
{
    [Route("health")]
    public class HealthController : ControllerBase
    {
        [HttpGet]
        public string Get()
        {
            return "ok";
        }
    }
}
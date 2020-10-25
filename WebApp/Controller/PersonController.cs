using System.Linq;
using Microsoft.AspNetCore.Mvc;
using NHibernate;
using WebApp.Model;

namespace WebApp.Controller
{
    [Route("/persons")]
    public class PersonController : ControllerBase
    {
        private readonly ISession _session;

        public PersonController(ISession session)
        {
            _session = session;
        }

        [HttpGet]
        public ActionResult Get()
        {
            return Ok(_session.Query<Person>().ToList());
        }
    }
}
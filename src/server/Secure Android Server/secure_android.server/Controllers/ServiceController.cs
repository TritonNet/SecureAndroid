using Microsoft.AspNetCore.Mvc;

namespace secure_android.server.Controllers
{
    public class HelloResponse
    {
        public string Message { get; set; }
    }

    [ApiController]
    [Route("/api/service")]
    public class ServiceController : ControllerBase
    {
        [HttpGet, Route("ping")]
        public IActionResult Ping()
        {
            return Ok("OK; It works");
        }

        [HttpPost, Route("")]
        public IActionResult Hello()
        {
            return Ok(new HelloResponse
            {
                Message = "Hello from Server x"
            });
        }
    }
}
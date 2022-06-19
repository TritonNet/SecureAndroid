using Microsoft.AspNetCore.Server.Kestrel.Https;

namespace secure_android.server.Controllers
{
    public class Program
    {
        public static void Main(string[] args)
        {
            CreateHostBuilder(args).Build().Run();
        }
        public static IHostBuilder CreateHostBuilder(string[] args) 
            => Host.CreateDefaultBuilder(args)
                    .ConfigureWebHostDefaults(webBuilder => 
                    {
                        webBuilder.UseStartup<Startup>();
                        webBuilder.ConfigureKestrel(o => 
                        {
                            o.ConfigureHttpsDefaults(o => o.ClientCertificateMode = ClientCertificateMode.AllowCertificate);
                        });
                    });
    }
}
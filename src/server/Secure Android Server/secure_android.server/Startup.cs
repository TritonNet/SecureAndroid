using Microsoft.AspNetCore.Authentication.Certificate;

namespace secure_android.server
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }
        public IConfiguration Configuration
        {
            get;
        }
        // This method gets called by the runtime. Use this method to add services to the container.
        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();
            services.AddTransient<CertificateValidation>();
            services.AddAuthentication(CertificateAuthenticationDefaults.AuthenticationScheme)
                        .AddCertificate(options =>
                        {
                            options.AllowedCertificateTypes = CertificateTypes.SelfSigned;
                            options.Events = new CertificateAuthenticationEvents
                            {
                                OnCertificateValidated = context =>
                                {
                                    var validationService = context.HttpContext.RequestServices.GetService<CertificateValidation>();
                                    if (validationService.ValidateCertificate(context.ClientCertificate))
                                    {
                                        context.Success();
                                    }
                                    else
                                    {
                                        context.Fail("Invalid certificate");
                                    }
                                    return Task.CompletedTask;
                                },
                                OnAuthenticationFailed = context =>
                                {
                                    context.Fail("Invalid certificate");
                                    return Task.CompletedTask;
                                }
                            };
                        });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }
            app.UseHttpsRedirection();
            app.UseRouting();
            app.UseAuthentication();
            app.UseAuthorization();
            app.UseEndpoints(endpoints => {
                endpoints.MapControllers();
            });
        }
    }
}

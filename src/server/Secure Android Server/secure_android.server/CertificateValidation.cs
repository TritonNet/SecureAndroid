using System.Security.Cryptography.X509Certificates;

namespace secure_android.server
{
    public class CertificateValidation
    {
        public bool ValidateCertificate(X509Certificate2 clientCertificate)
        {
            string[] allowedThumbprints = {
                "7ED035ABAB1B8CCDFF561935D3C55BE91EAB3DFB"
            };
            if (allowedThumbprints.Contains(clientCertificate.Thumbprint))
            {
                return true;
            }
            return false;
        }
    }
}

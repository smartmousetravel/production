{ lib, ... }:
{
  resource =
    let
      zone = "smartmouse";
      domain = "smartmousetravel.com.";
    in
    {
      google_dns_managed_zone.smartmouse = {
        name = zone;
        dns_name = domain;
        description = domain;
      };

      google_dns_record_set.smartmouse_ns = {
        name = domain;
        managed_zone = zone;
        type = "NS";
        ttl = 21600;
        rrdatas = [
          "ns-cloud-d1.googledomains.com."
          "ns-cloud-d2.googledomains.com."
          "ns-cloud-d3.googledomains.com."
          "ns-cloud-d4.googledomains.com."
        ];
      };

      google_dns_record_set.smartmouse_soa = {
        name = domain;
        managed_zone = zone;
        type = "SOA";
        ttl = 21600;
        rrdatas = [
          "ns-cloud-d1.googledomains.com. cloud-dns-hostmaster.google.com. 1 21600 3600 259200 300"
        ];
      };

      google_dns_record_set.smartmouse_a = {
        name = domain;
        managed_zone = zone;
        type = "A";
        ttl = 300;
        rrdatas = [ (lib.tfRef "google_compute_address.buckbeak.address") ];
      };
      google_dns_record_set.smartmouse_a_www = {
        name = "www.${domain}";
        managed_zone = zone;
        type = "A";
        ttl = 300;
        rrdatas = [ (lib.tfRef "google_compute_address.buckbeak.address") ];
      };

      google_dns_record_set.smartmouse_txt_spf = {
        name = domain;
        managed_zone = zone;
        type = "TXT";
        ttl = 300;
        rrdatas = [
          "\"v=spf1 mx include:spf.mailjet.com include:_spf.google.com ~all\""
          "\"google-site-verification=D6l9I-23ZHhXO1Id1T7n9ChkmxGbJGrncOYxd7x1VsQ\""
          "\"google-site-verification=pBexVPeVnGLafFgthpXu_p-MekeSS5-kBD2Rd3dI4Dc\""
        ];
      };

      # Records for MailJet integrations
      google_dns_record_set.smartmouse_txt_mailjet = {
        name = "mailjet._7337ba57.${domain}";
        managed_zone = zone;
        type = "TXT";
        ttl = 300;
        rrdatas = [ "\"7337ba570495cc0bb35e2e16367d3294\"" ];
      };
      google_dns_record_set.smartmouse_txt_k1_mailjet = {
        name = "k1._domainkey.${domain}";
        managed_zone = zone;
        type = "TXT";
        ttl = 300;
        rrdatas = [
          "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDYkL3OeK9QkxZiqToZ8mK2ELy5Ah6TyHtqhH6cxCa+mIwzFwTJVCjBsWJTg3wwdoUyz2Q+CpddJUfTXiakWpSTskPeMpSl6QWrDd/vlCaaUwbWS/dqPG8Iemu6jkdOPp2x3616vE7tsC6qwjXzEkOdXgC0DxDhaX2OEzeg4YfXawIDAQAB\""
        ];
      };
      google_dns_record_set.smartmouse_txt_domainkey_mailjet = {
        name = "mailjet._domainkey.${domain}";
        managed_zone = zone;
        type = "TXT";
        ttl = 300;
        rrdatas = [
          "\"k=rsa; p=MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC7Wqv5433xodyKyRWRaPWZzJwYZb35KXfVCRGxjqnHyhrTNltfwfVM3G183LXkh3j4qCe0GRt4o0K5PQ2fqc0modUzBiMg+g3Tisdf8+2Db538JvL3U/2RO6BtESxRd7CpY1Za5caajytJjsIeyKG80tsC8b4B2EYy1ce1PyNXLwIDAQAB\""
        ];
      };
      google_dns_record_set.smartmouse_txt_bnc3_mailjet = {
        name = "bnc3.${domain}";
        managed_zone = zone;
        type = "CNAME";
        ttl = 300;
        rrdatas = [ "bnc3.mailjet.com." ];
      };
    };
}

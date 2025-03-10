{ pkgs, ... }:
let
  site = "buckbeak.smartmousetravel.com";
  fetchTheme =
    {
      name,
      version,
      hash,
    }:
    pkgs.stdenv.mkDerivation rec {
      inherit name version hash;
      src = pkgs.fetchzip {
        inherit name version hash;
        url = "https://downloads.wordpress.org/theme/${name}.${version}.zip";
      };
      installPhase = "mkdir -p $out; cp -R * $out/";
    };
in
{
  services.wordpress = {
    webserver = "nginx";

    sites."${site}" = {
      uploadsDir = "/wp/uploads";
      plugins = { };
      themes = {
        astra = fetchTheme {
          name = "astra";
          version = "4.9.0";
          hash = "sha256-m146BCsWRXkfH9gi36burYDpEdzwWgMRsu1v6n1yGsA=";
        };
      };

      database.socket = "/run/mysqld/mysqld.sock";
    };
  };

  services.nginx.virtualHosts."${site}" = {
    enableACME = true;
    forceSSL = true;
  };

  # TODO: Why does setting this in security.acme.defaults fail?
  security.acme.certs.${site} = {
    dnsProvider = "gcloud";
    webroot = null;
  };
}

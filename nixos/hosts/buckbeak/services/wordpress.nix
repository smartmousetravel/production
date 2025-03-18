{ pkgs, pkgs-smt, ... }:
let
  site = "buckbeak.smartmousetravel.com";
  assets = builtins.fromJSON (builtins.readFile ./wordpress-assets.json);
in
{
  services.wordpress = {
    webserver = "nginx";

    sites."${site}" =
      let
        fetchAsset =
          name:
          {
            version,
            url,
            hash,
          }:
          pkgs.stdenv.mkDerivation {
            inherit name version hash;
            src = pkgs.fetchurl {
              inherit
                name
                version
                url
                hash
                ;
            };
            buildInputs = [ pkgs.unzip ];
            dontUnpack = true;
            installPhase = "mkdir -p $out; unzip $src -d $out/";
          };
        inherit (pkgs.lib.attrsets) mapAttrs;
      in
      {
        uploadsDir = "/wp/uploads";
        plugins = mapAttrs fetchAsset assets.plugins;
        themes = {
          inherit (pkgs-smt) astra-smt;
        } // (mapAttrs fetchAsset assets.themes);
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

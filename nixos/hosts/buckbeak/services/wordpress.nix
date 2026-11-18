{ pkgs, pkgs-smt, ... }:
let
  site = "smartmousetravel.com";
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
            buildInputs = [ pkgs.libarchive ];
            dontUnpack = true;
            installPhase = ''
              runHook preInstall
              mkdir -p $out
              bsdtar --strip-components=1 -xf $src -C $out/
              runHook postInstall
            '';
          };
        inherit (pkgs.lib.attrsets) mapAttrs;
      in
      {
        uploadsDir = "/wp/uploads";
        plugins = mapAttrs fetchAsset assets.plugins;
        themes = {
          inherit (pkgs-smt) astra-smt;
        }
        // (mapAttrs fetchAsset assets.themes);
        database.socket = "/run/mysqld/mysqld.sock";
      };
  };

  services.nginx = {
    # Temporary security override until nixos-26.05 picks up nixpkgs PR #589970
    # (CVE-2026-123007, CVE-2026-118899, CVE-2026-113425, CVE-2026-123634, etc.)
    package = pkgs.nginxStable.overrideAttrs (rec {
      version = "1.30.7";
      nginxVersion = version;
      src = pkgs.fetchurl {
        url = "https://nginx.org/download/nginx-${version}.tar.gz";
        hash = "sha256-JWW1yDcFDpWPcPsPc8SOK8pFQq00n9NW9G+wxyYQvG4=";
      };
    });
    clientMaxBodySize = "20m";
    mapHashBucketSize = 128;
    commonHttpConfig = ''
      map $request_uri $new_uri {
        include ${./nginx.map};
      }
    '';

    virtualHosts."${site}" = {
      enableACME = true;
      forceSSL = true;

      # Use the redirects loaded from nginx.map
      extraConfig = ''
        if ($new_uri) {
          return 301 $new_uri;
        }
      '';

      # Redirect /yyyy/mm/dd/WHATEVER/ to /WHATEVER/
      locations."/".extraConfig = ''
        rewrite ^/[0-9][0-9][0-9][0-9]/[0-9][0-9]/[0-9][0-9]/([^/]+)/$ /$1/ permanent;
      '';
    };
  };

  # TODO: Why does setting this in security.acme.defaults fail?
  security.acme.certs.${site} = {
    dnsProvider = "gcloud";
    webroot = null;
  };
}

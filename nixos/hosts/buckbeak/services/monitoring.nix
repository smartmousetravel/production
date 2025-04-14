{
  config,
  lib,
  pkgs,
  ...
}:
let
  promcfg = config.services.prometheus;
  mkYAML =
    name: path: attrs:
    pkgs.writeText name (builtins.toJSON (import path attrs));
in
{
  services.prometheus = {
    enable = true;
    listenAddress = "[::1]";
    ruleFiles = [
      (mkYAML "prober_home_dns.rules" ./monitoring_rules.nix { })
    ];

    scrapeConfigs = [
      {
        job_name = "node";
        static_configs = [ { targets = [ "[::1]:${toString promcfg.exporters.node.port}" ]; } ];
        relabel_configs = [
          {
            source_labels = [ "__address__" ];
            regex = "(.+):(.*)$";
            target_label = "instance";
            replacement = "buckbeak:$2";
          }
        ];
      }
    ];

    exporters = {
      node = {
        enable = true;
        listenAddress = "[::1]";
        enabledCollectors = [ "systemd" ];
      };
    };
  };
}

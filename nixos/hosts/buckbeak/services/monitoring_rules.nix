{ }:
let
  mkRates =
    counter:
    builtins.map
      (rate: {
        record = "${counter}:rate${rate}";
        expr = "rate(${counter}[${rate}])";
      })
      [
        "1m"
        "5m"
      ];
in
{
  groups = [
    {
      name = "node_net";
      rules =
        [
          {
            record = "node:receive_bytes";
            expr = "node_network_receive_bytes_total{device=~'^(en|eth).*'}";
          }
          {
            record = "node:transmit_bytes";
            expr = "node_network_transmit_bytes_total{device=~'^(en|eth).*'}";
          }
        ]
        ++ (mkRates "node:receive_bytes")
        ++ (mkRates "node:transmit_bytes");
    }
    {
      name = "node_fs";
      rules =
        [
          {
            record = "node:filesystem_avail_bytes";
            expr = "node_filesystem_avail_bytes{job='node',fstype!~'(tmpfs|ramfs)'}";
          }
          {
            record = "node:disk_read_seconds";
            expr = "node_disk_read_time_seconds_total";
          }
          {
            record = "node:disk_write_seconds";
            expr = "node_disk_write_time_seconds_total";
          }
        ]
        ++ (mkRates "node:disk_read_seconds")
        ++ (mkRates "node:disk_write_seconds");
    }
    {
      name = "node_cpu";
      rules = [
        {
          record = "node:cpu_seconds";
          expr = "sum(node_cpu_seconds_total) by (instance, mode)";
        }
      ] ++ (mkRates "node:cpu_seconds");
    }
  ];
}

final: prev:
let
  phpSet = prev.callPackage (prev.path + "/pkgs/development/interpreters/php") {
    callPackage =
      fn: args:
      prev.callPackage fn (
        args
        // prev.lib.optionalAttrs (prev.lib.hasPrefix "8.4" args.version) {
          version = "8.4.27";
          hash = "sha256-slMKh3xyL0sIyeF0owywi6wrfhkD7m6eMV8KqfX4LCQ=";
          packageOverrides = finalPkgs: prevPkgs: {
            extensions = prevPkgs.extensions // {
              fileinfo = prevPkgs.extensions.fileinfo.overrideAttrs (_: {
                doCheck = false;
              });
              filter = prevPkgs.extensions.filter.overrideAttrs (_: {
                doCheck = false;
              });
            };
          };
        }
      );
  };
in
{
  php84 = phpSet.php84;
  php = final.php84;
}

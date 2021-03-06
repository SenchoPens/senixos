{ lib, config, ... }:
let
  mkKeyValue = key: value:
    let

      mvalue = if builtins.isBool value then
        (if value then "true" else "false")
      else if (builtins.isString value && key != "include-file") then
        value
      else
        builtins.toString value;

    in "${key}=${mvalue}";

  attrsToList = with builtins;
    x:
    (map (key: {
      name = key;
      value = getAttr key x;
    }) (attrNames x));

in rec {
  genIni = lib.generators.toINI { inherit mkKeyValue; };

  genIniOrdered = lst:
    (builtins.concatStringsSep "\n" (map ({ name ? "widget", ... }@attrs:
      builtins.concatStringsSep "\n" ([ "[${name}]" ]
        ++ (map ({ name, value }: mkKeyValue name value)
          (attrsToList (builtins.removeAttrs attrs [ "name" ]))))) lst)) + "\n";
}

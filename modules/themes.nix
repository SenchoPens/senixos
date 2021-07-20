{ config, lib, pkgs, inputs, ... }:
with lib;
{
  config.base16.schemes = rec {
    # light = inputs.base16.lib.x86_64-linux.getSchemeFromYAMLPath "${inputs.base16-black-metal-schemes}/black-metal-burzum.yaml";
    dark = inputs.base16.lib.x86_64-linux.getSchemeFromYAMLPath "${inputs.base16-black-metal-schemes}/black-metal-burzum.yaml";

    default = dark;
  };
}

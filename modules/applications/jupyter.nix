{ config, pkgs, lib, ... }:
{
  services.jupyter = {
    enable = true;

    #dunno. does not work. use jupyterWith
    group = "users";
    user = "sencho";
    command = "jupyter-notebook";
    password = "'sha1:1b961dc713fb:88483270a63e57d18d43cf337e629539de1436ba'";
    kernels = {
      python3 = let
        env = (pkgs.python3.withPackages (pythonPackages: with pythonPackages; [
            ipykernel
            pandas
            scikitlearn
            scipy
            matplotlib
            seaborn
          ]));
        in {
          displayName = "Python 3 for machine learning";
          argv = [
            "${env.interpreter}"
            "-m"
            "ipykernel_launcher"
            "-f"
            "{connection_file}"
          ];
          language = "ML Python 3";
          # logo32 = "${env.sitePackages}/ipykernel/resources/logo-32x32.png";
          # logo64 = "${env.sitePackages}/ipykernel/resources/logo-64x64.png";
        };
    };
  };
}

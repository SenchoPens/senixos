self: super: {
  # ydotool = super.ydotool.overrideAttrs (old: {
  #   version="blabla";
  #   src = super.fetchFromGitHub {
  #     owner = "ReimuNotMoe";
  #     repo = "ydotool";
  #     rev = "4782e9eb7bffc986c39172454e54d4c1d9808c64";
  #     sha256 = "sha256-rl3HySdVC9vM0hotCyNg2PsyLeJRNZac/sLnSnTZSG4=";
  #   };
  # });

  # alacritty = super.alacritty.overrideAttrs (old: 
  # let 
  #   powerline-patch = super.fetchFromGitHub {
  #     owner = "iamjamestl";
  #     repo = "crossfont";
  #     rev = "69a7c86fef3a2b0d11608ca25a6f793eb2f8c7c7";
  #     sha256 = "sha256-vlyFEk0m2khxn+p/CYymlhtfjj49Yk10SqXp0OlLmlA=";
  #   };
  # in {
  #   patches = [
  #     (super.writeText "alacritty.patch" ''
  #       diff -ur a/source/Cargo.toml b/source/Cargo.toml
  #       --- source/Cargo.toml	1970-01-01 03:00:01.000000000 +0300
  #       +++ source/Cargo.toml	2020-09-04 00:14:23.403387358 +0300
  #       @@ -8,3 +8,6 @@
  #        lto = true
  #        debug = 1
  #        incremental = false
  #       +
  #       +[patch.crates-io]
  #       +crossfont = { path = "${powerline-patch}" }
  #     '')
  #   ];
  #   postPatch = ''
  #     cargo update
  #   '';
  # });
}

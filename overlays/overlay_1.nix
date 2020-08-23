self: super: {
  ydotool = super.ydotool.overrideAttrs (old: {
    version="blabla";
    src = super.fetchFromGitHub {
      owner = "ReimuNotMoe";
      repo = "ydotool";
      rev = "4782e9eb7bffc986c39172454e54d4c1d9808c64";
      sha256 = "sha256-rl3HySdVC9vM0hotCyNg2PsyLeJRNZac/sLnSnTZSG4=";
    };
  });
}

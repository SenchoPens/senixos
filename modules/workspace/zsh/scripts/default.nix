p: c:

with p; 
builtins.mapAttrs 
  (name: value:
    stdenv.mkDerivation {
      inherit name;
      src = value;
      unpackPhase = "true";
      buildInputs = [ghc];
      buildPhase = "ghc -o $out $src";
      installPhase = "true";
    })
  {
    hse-dir = ./hse-dir.hs;
  }

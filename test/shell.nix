{ buildMusl ? false
, compiler-nix-name ? "ghc884"
}:
let
  er-nix = import ../default.nix;
  pkgs = er-nix.pkgs;
  hsPkgs = import ./default.nix { inherit pkgs buildMusl compiler-nix-name; };
in
hsPkgs.shellFor {
  tools = {
    cabal = "3.2.0.0";
    ghcide = "0.4.0";
    hpack = "0.34.2";
  };

  buildInputs = [];
}

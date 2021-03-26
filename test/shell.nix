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
    cabal = "3.4.0.0";
    haskell-language-server = "latest";
    hpack = "0.34.3";
  };

  buildInputs = builtins.attrValues er-nix.tools.hopenpgp-tools;
}

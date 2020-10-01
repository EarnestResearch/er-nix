{ buildMusl
, compiler-nix-name
}:
let
  er-nix = import ../default.nix;
  pkgs = er-nix.pkgs;
  hsPkgs = import ./default.nix { inherit pkgs buildMusl compiler-nix-name; };
  hls = er-nix.tools.haskell-language-server { project = hsPkgs.earnest-project; };
in
hsPkgs.shellFor {
  tools = {
    cabal = "3.2.0.0";
  };

  buildInputs = builtins.attrValues hls;

  exactDeps = true;
}

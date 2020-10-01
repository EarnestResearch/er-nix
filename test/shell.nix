{ buildMusl
, compiler-nix-name
}:
let
  pkgs = (import ../default.nix).pkgs;
  hsPkgs = import ./default.nix { inherit pkgs buildMusl compiler-nix-name; };
in
hsPkgs.shellFor {
  tools = {
    cabal = "3.2.0.0";
    ghcide = "0.2.0";
  };

  exactDeps = true;
}

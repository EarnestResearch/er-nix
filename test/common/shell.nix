let
  pkgs = (import ../../default.nix).pkgs;
  hsPkgs = import ./default.nix { inherit pkgs; };
in
hsPkgs.shellFor {
  tools = {
    cabal = "3.2.0.0";
    ghcide = "0.2.0";
  };

  exactDeps = true;
}

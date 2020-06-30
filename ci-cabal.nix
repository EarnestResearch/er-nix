{ ghc }:
with (import ./.);
{
  cabal = pkgs.buildPackages.haskell-nix.tool "cabal" {
    version = "3.2.0.0";
    compiler-nix-name = ghc;
  };
}

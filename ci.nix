{ ghc }:
with (import ./.);
{
  nix-tools = pkgs.haskell-nix.nix-tools;
  cabal = pkgs.haskell-nix.tool "cabal" {
    version = "3.2.0.0";
    compiler-nix-name = ghc;
  };
}

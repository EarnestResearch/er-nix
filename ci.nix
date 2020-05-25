{ ghc }:
with (import ./.);
{
  nix-tools = pkgs.haskell-nix.nix-tools;
  ghcide = pkgs.haskell-nix.tool "ghcide" {
    version = "object-code";
    compiler-nix-name = ghc;
  };
}

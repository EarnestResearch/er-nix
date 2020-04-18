{ ghc }:
with (import ./.);

{
  nix-tools = pkgs.haskell-nix.nix-tools;
  ghc = builtins.getAttr ghc pkgs.buildPackages.pkgs.haskell-nix.compiler;
}

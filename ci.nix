with (import ./.);

{
  nix-tools = pkgs.haskell-nix.nix-tools;
  inherit (pkgs.haskell-nix.compiler) ghc865;
}

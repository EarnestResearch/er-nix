with (import ./.);

{
  fd = pkgs.fd;
  hlint = pkgs.hlint;
  git = pkgs.git;
  ormolu = pkgs.ormolu;
  nix-tools = pkgs.haskell-nix.nix-tools;
  stack = pkgs.stack;
  inherit (pkgs.haskell-nix.compiler) ghc865;
}

let
  sources = import ../nix/sources.nix;
  pre-commit-hooks = import sources.pre-commit-hooks;
in
pre-commit-hooks.run {
  src = ./.;
  hooks = {
    hlint.enable = true;
    nixpkgs-fmt.enable = true;
    ormolu.enable = true;
  };
}

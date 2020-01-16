let
  sources = import ./nix/sources.nix;
in
{
  defaultNixpkgs = import sources.nixpkgs;
  nixpkgsArgs = import ./overlays;
  ides = import ./ides;

  inherit (import sources.niv {}) niv;
}

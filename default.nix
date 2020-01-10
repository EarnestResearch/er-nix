{
  defaultNixpkgs = (import ./sources).nixpkgs;
  nixpkgsArgs = import ./overlays;
  ides = import ./ides;
}

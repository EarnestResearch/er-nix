let
  sources = import ./nix/sources.nix;
  haskell-nix = import sources.haskell-nix {};
in
rec {
  # A pinned version of nixpkgs, widely used and hopefully well cached.
  defaultNixpkgs = import sources.nixpkgs;

  # A package set for the specified system, based on `defaultNixpkgs` with all overlays applied.
  pkgsForSystem = system: defaultNixpkgs (nixpkgsArgs // { inherit system; });

  # `pkgsForSystem` for the current system.
  pkgs = pkgsForSystem builtins.currentSystem;

  # Args to apply to any nixpkgs to generate a package set with the overlays.
  nixpkgsArgs = haskell-nix.nixpkgsArgs // { inherit overlays; };

  # All the haskell.nix overlays plus all the er-nix overlays.
  overlays = haskell-nix.overlays ++ (import ./overlays);

  inherit (import sources.niv {}) niv;
}

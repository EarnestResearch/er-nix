{ sources ? import ./nix/sources.nix }:
with {
  nivOverlay = _: pkgs: {
    pre-commit-hooks = (import sources.niv { }).pre-commit-hooks;
  };
  erOverlays = import ./overlays;
};
import sources.nixpkgs {
  overlays = [ nivOverlay ] ++ erOverlays;
  config = { };
}

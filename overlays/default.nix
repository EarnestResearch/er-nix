let
  sources = import ../nix/sources.nix;
  upstreamHaskellNix = import sources.haskell-nix;
  localOverlays =
    [
      (import ./pin-stackage.nix)
      (import ./icu.nix)
      (import ./earnestresearch.nix)
    ];
in
upstreamHaskellNix // { overlays = upstreamHaskellNix.overlays ++ localOverlays; }

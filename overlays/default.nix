# All local overlays provided by er-nix.
[
  (import ./darwin.nix)
  (import ./custom-packages.nix)
  (import ./hpack.nix)
  (import ./earnestresearch.nix)
]

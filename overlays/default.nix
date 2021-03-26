# All local overlays provided by er-nix.
[
  (import ./darwin.nix)
  (import ./custom-packages.nix)
  (import ./hpack.nix)
  (import ./input-parsers.nix)
  (import ./aliases.nix)
  (import ./earnestresearch.nix)
]

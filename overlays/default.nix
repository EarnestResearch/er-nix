# All local overlays provided by er-nix.
[
  (import ./darwin.nix)
  (import ./eksctl.nix)
  (import ./custom-packages.nix)
  (import ./earnestresearch.nix)
  (import ./ghcide.nix)
  (import ./pantry.nix)
]

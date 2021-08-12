{ pkgs ? import ./. { } }:

pkgs.mkShell {
  inherit (pkgs.earnestresearch.pre-commit-check) shellHook;
  buildInputs = [ pkgs.niv pkgs.nixpkgs-fmt ];
}

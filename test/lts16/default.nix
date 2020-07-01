{ pkgs ? (import ../../default.nix).pkgs
, buildMusl
}:
let
  crossPkgs = if buildMusl then pkgs.pkgsCross.musl64 else pkgs;
in
pkgs.haskell-nix.project {
  src = ./.;
}

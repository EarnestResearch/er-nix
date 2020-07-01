{ pkgs ? (import ../../default.nix).pkgs
, buildMusl
}:
let
  crossPkgs = if buildMusl then pkgs.pkgsCross.musl64 else pkgs;
in
crossPkgs.haskell-nix.project {
  src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
}

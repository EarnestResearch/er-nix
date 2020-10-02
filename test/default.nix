{ pkgs ? (import ../default.nix).pkgs
, buildMusl
, compiler-nix-name
}:
let
  crossPkgs = if buildMusl then pkgs.pkgsCross.musl64 else pkgs;
in
crossPkgs.haskell-nix.cabalProject {
  name = "earnest-project";
  src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
  inherit compiler-nix-name;
}

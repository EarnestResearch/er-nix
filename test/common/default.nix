{ pkgs ? (import ../../default.nix).pkgs
}:
pkgs.haskell-nix.project {
  src = pkgs.haskell-nix.haskellLib.cleanGit { src = ./.; };
}

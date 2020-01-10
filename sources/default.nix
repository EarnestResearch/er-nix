let
  fetcher = { url, rev, sha256, ... }:
    builtins.fetchTarball {
      inherit sha256;
      url = "${url}/tarball/${rev}";
    };
  load = _: pinFile: import (fetcher (builtins.fromJSON (builtins.readFile pinFile)));
in
builtins.mapAttrs load {
  nixpkgs = ../pins/default-nixpkgs.json;
  unstable-nixpkgs = ../pins/unstable-nixpkgs.json;
  all-hies = ../pins/default-all-hies.json;
  haskell-nix = ../pins/default-haskell-nix.json;
  pre-commit-hooks = ../pins/default-pre-commit-hooks.json;
}

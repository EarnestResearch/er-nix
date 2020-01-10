let
  fetcher = import ../fetcher.nix;
  nixpkgsPin = builtins.fromJSON (builtins.readFile ../pins/default-nixpkgs.json);
in
import (fetcher nixpkgsPin)

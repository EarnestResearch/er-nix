#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nix-prefetch-git

set -euo pipefail

PINS_DIR=`dirname $0`

nix-prefetch-git https://github.com/NixOS/nixpkgs \
                 --rev refs/heads/nixpkgs-19.09-darwin \
                 > $PINS_DIR/default-nixpkgs.json

nix-prefetch-git https://github.com/fiadliel/stackage.nix \
                 > $PINS_DIR/default-stackage.json

nix-prefetch-git https://github.com/input-output-hk/haskell.nix \
                 > $PINS_DIR/default-haskell-nix.json

nix-prefetch-git https://github.com/hercules-ci/pre-commit-hooks.nix \
                 > $PINS_DIR/default-pre-commit-hooks.json

nix-prefetch-git https://github.com/infinisil/all-hies \
                 > $PINS_DIR/default-all-hies.json

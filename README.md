# er-nix

Common Nix code for Earnest Research

## Quick start

To start using this, you can call it like

```
let
  pkgs = import (builtins.fetchGit {
    url = "git@github.com:EarnestResearch/er-nix";
    ref = "refs/heads/master";
    # git ls-remote git@github.com:EarnestResearch/er-nix refs/heads/master | awk '{ print "rev = \""$1"\";" }'
    rev = "127c670a010cb60f3cd6bc89b2622562ae3ba82b";
  }) {}
in
  ...
```

This will provide a patched nixpkgs which includes haskell-nix and some local changes, for the current system.

## Building for another platform

Instead of passing `{}` to nixpkgs, pass `{ system = "x86_64-linux" }` to build on the Linux platform instead.

## Building Docker images

If you have a Docker image (built with `dockerTools.buildImage`, you can push this to AWS ECR with something like:

```
with (import ./nixpkgs {});
let
  dockerBuild = <Docker derivation here>;
in

callPackage earnestresearch.lib.docker.upload-to-aws {
  dockerArchive = dockerBuild;
  dockerName = "my-service";
  dockerTag = builtins.getEnv "CODEBUILD_RESOLVED_SOURCE_VERSION";
}
```

One can invoke this (if it's in the file release.nix):

```
nix-build -L -f ./release.nix
```

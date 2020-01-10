# er-nix

Common Nix code for Earnest Research

## Quick start

To start using this, you can call it like

```
let
  pkgs = import (builtins.fetchGit {
    url = "git@github.com:EarnestResearch/er-nix";
    ref = "refs/heads/master";
    rev = "e4813e235ec3a39b31fef1f306e8ac2a73a37031";
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

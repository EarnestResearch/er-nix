# er-nix

Common Nix code for Earnest Research

## Quick start

### `nixpkgs/default.nix`

Put the following in `nixpkgs/default.nix`:

```nix
{ system ? builtins.currentSystem }:

let
  er-nix = import (builtins.fetchGit {
    url = "git@github.com:EarnestResearch/er-nix";
    ref = "refs/heads/master";
    # git ls-remote git@github.com:EarnestResearch/er-nix refs/heads/master | awk '{ print "rev = \""$1"\";" }'
    rev = "127c670a010cb60f3cd6bc89b2622562ae3ba82b";
  });
in
  er-nix.pkgsForSystem(system)
```

This will provide a patched nixpkgs which includes [haskell-nix](https://github.com/input-output-hk/haskell.nix) and some local changes for the current system.

### `default.nix`

Import nixpkgs like this:

```nix
let
  pkgs = import ./nixpkgs {};
in
  { /* your derivation here */ }
```

### Cross-system builds

The build can be parameterized on `system`, for instance to support building Docker images from a MacBook using a [remote builder](https://github.com/LnL7/nix-docker/#running-as-a-remote-builder).  Pass it as an argument to your `./nixpkgs`:

```nix
{ system ? builtins.currentSystem }:

let
  pkgs = import ./nixpkgs { inherit system; };
in
  { /* your derivation here */ }
```

The system can then be overridden from the command line:

```sh
nix build -L -f . --argstr system x86_64-linux
```

## Building Docker images

If you have a Docker image (built with `dockerTools.buildImage`, you can push this to AWS ECR with something like:

```nix
with (import ./nixpkgs {});
let
  dockerBuild = { /* Docker derivation here */ };
in

callPackage earnestresearch.lib.docker.upload-to-aws {
  dockerArchive = dockerBuild;
  dockerName = "my-service";
  dockerTag = builtins.getEnv "CODEBUILD_RESOLVED_SOURCE_VERSION";
}
```

One can invoke this (if it's in the file release.nix):

```sh
nix-build -L -f ./release.nix
```

## Development

### Updating sources

We use [niv](https://github.com/nmattia/niv) to manage our source pins.  `niv` is available in the nix-shell for this project.  To update a single source:

```sh
niv update nixpkgs-unstable
```

To update all sources:

```sh
niv update
```

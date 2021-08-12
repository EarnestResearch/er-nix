# er-nix

Common Nix code for Earnest Research

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [er-nix](#er-nix)
    - [Installing our development tools](#installing-our-development-tools)
    - [Quick start](#quick-start)
        - [`nixpkgs/default.nix`](#nixpkgsdefaultnix)
        - [`default.nix`](#defaultnix)
    - [Building Docker images for AWS environment](#building-docker-images-for-aws-environment)
    - [Cabal utilities](#cabal-utilities)
        - [hopenpgp-tools](#hopenpgp-tools)
    - [Development](#development)
        - [Updating sources](#updating-sources)
        - [Automated updates](#automated-updates)

<!-- markdown-toc end -->

## Installing our development tools

If you are a nix enthusiast / power user please take a look at [Nix Home Manager](https://nixos.wiki/wiki/Home_Manager), otherwise read on for a simple setup.

This is a way to share our development tools with all developers via a custom nix channel.

Make sure `~/.nix-profile/bin` is in your `PATH`.

Add this repository as a nix channel:

```bash
$ nix-channel --add  https://github.com/EarnestResearch/er-nix/archive/master.tar.gz er-nix
```
(or verify you have it already with `nix-channel --list`)

Use it to install our packages, e.g.
```bash
$ nix-channel --update
```

To keep up with new releases:

```bash
$ nix-channel --update
$ nix-env --upgrade
```

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

This will provide our nix tools maintained in this repository.

### `default.nix`

Import nixpkgs like this:

```nix
let
  pkgs = import ./nixpkgs {};
in
  { /* your derivation here */ }
```

## Building Docker images for AWS environment

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

## Cabal utilities

Load in your `shell.nix`

```nix
let
  hsPkgs = import ./default.nix { inherit pkgs; };
  cabalProject = pkgs.earnestresearch.lib.cabal.project hsPkgs "your-project-name";
```

and then add `cabal new-run` shell wrappers for all executables defined in your project with

```nix
  buildInputs = with pkgs; [
  ...other stuff...
  ] ++ cabalProject.projectApps;
```

### hopenpgp-tools

`hopenpgp-tools` is referenced in Earnest's GPG instructions, but currently marked as broken in vanilla nixpkgs.
We provide a working derivation here as a convenience.
To add it to your environment:

```sh
nix-env -if https://github.com/EarnestResearch/er-nix/tarball/master -A tools.hopenpgp-tools
```

home-manager users can add the values to `home.packages`:

```nix
let
  er-nix = import sources.er-nix;
{
  home.packages = [
    # Your other nixpkgs here
  ] ++ builtins.attrValues er-nix.tools.hopenpgp-tools;
}
```

## Development

### Updating sources

We use [niv](https://github.com/nmattia/niv) to manage our source pins.  `niv` is available in the nix-shell for this project.  To update a single source:

```sh
niv update nixpkgs
```

To update all sources:

```sh
niv update
```

### Automated updates

The `upgrade.yml` workflow runs a niv update and fetches the latest LTS on the second and fourth Tuesday of every month.

It is not uncommon for builds to time out, particularly on ghc-8.10.4.  Typically someone has to restart it.  Enough forward progress is made in cachix, it usually works the second or third time, depending on how much changed.

To improve cache hits in projects, copy `test/cabal.project.freeze` into your project or template.  There is not currently any automation around this process.

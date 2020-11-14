# er-nix

Common Nix code for Earnest Research

<!-- markdown-toc start - Don't edit this section. Run M-x markdown-toc-refresh-toc -->
**Table of Contents**

- [er-nix](#er-nix)
    - [Installing our development tools](#installing-our-development-tools)
    - [Quick start](#quick-start)
        - [`nixpkgs/default.nix`](#nixpkgsdefaultnix)
        - [`default.nix`](#defaultnix)
        - [Cross-system builds](#cross-system-builds)
    - [Building Docker images](#building-docker-images)
    - [Cabal utilities](#cabal-utilities)
    - [Custom packages](#custom-packages)
    - [Tools](#tools)
        - [haskell-language-server](#haskell-language-server)
    - [Development](#development)
        - [Updating sources](#updating-sources)

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
$ nix-env -f '<er-nix>' -i  -A 'pkgs.okta-aws-login'
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

## Custom packages

`er-nix.pkgs` provides some additional packages not available in the standard nixpkgs.  These may be useful in your own development configurations:

* [`haskell-nix`](https://input-output-hk.github.io/haskell.nix/)
* [`okta-aws-login`](https://github.com/EarnestResearch/okta-aws-login)

## Tools

We also add some development tools in `er-nix.tools`.
One reason they're distinct from packages is that they may require arguments to configure.
`pkgs.haskell-nix.tool` provides a lot, so this is mainly a holding area for things that aren't yet there.

### haskell-language-server

[Haskell Language Server](https://github.com/haskell/haskell-language-server) is a language server implementation that should work in any editor with an LSP client.
It must be compiled with the same version of `ghc` as used by the project.
We provide a function here to fetch the `haskell-language-server-wrapper` and cached `haskell-language-server` binaries for various Haskell versions.
To add it to your environment:

```sh
nix-env -if https://github.com/EarnestResearch/er-nix/tarball/master -A tools.haskell-language-servers
```

home-manager users can add the values to `home.packages`:

```nix
let
  er-nix = import sources.er-nix;
{
  home.packages = [
    # Your other nixpkgs here
  ] ++ builtins.attrValues er-nix.tools.haskell-language-servers;
}
```

There is also a `tools.haskellLanguageServersFor` function that takes an array of ghcVersions, but this isn't guaranteed to be in our cachix.
If you need more, please consider a PR here.

### hopenpgp-tools

`hopenpgp-tools` is referenced in Earnest's GPG instructions, but currently marked as broken.
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
niv update nixpkgs-unstable
```

To update all sources:

```sh
niv update
```

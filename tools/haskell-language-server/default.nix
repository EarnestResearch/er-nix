{ fetchFromGitHub
, haskell-nix
, lib
, sources
}:

let
  index-state-hashes = import haskell-nix.indexStateHashesPath;
in
{ ghcVersion
, index-state ? lib.last (builtins.attrNames index-state-hashes)
, index-sha256 ? null
}: import sources.nix-hls {
  inherit ghcVersion index-state index-sha256;
  sources = {
    # This has a submodule, which niv doesn't yet handle.
    # Note that this also defeats nix-prefetch-git.
    # https://github.com/nmattia/niv/issues/229
    haskell-language-server =
      with sources.haskell-language-server;
      fetchFromGitHub {
        inherit owner repo rev sha256;
        name = "haskell-language-server-src";
        fetchSubmodules = true;
      };
    "haskell.nix" = sources.haskell-nix;
  };
}

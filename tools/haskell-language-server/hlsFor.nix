{ callPackage }:

{ ghcVersions
, sources
}:
let
  hlsPkgs = ghcVersion: callPackage ./. {} {
    inherit ghcVersion sources;
    index-state = null;
    index-sha256 = null;
  };
  wrapperGhcVersion = builtins.head ghcVersions;
in
builtins.foldl' (bins: ghcv: bins // {
  "haskell-language-server-${ghcv}" = (hlsPkgs ghcv).hls-renamed;
}) {
  "haskell-language-server-wrapper" = (hlsPkgs wrapperGhcVersion).hls-wrapper;
} ghcVersions

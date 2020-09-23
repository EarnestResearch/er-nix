{ sources }:

ghcVersion: import sources.nix-hls {
  inherit ghcVersion;
  sources = {
    inherit (sources) haskell-language-server;
    "haskell.nix" = sources.haskell-nix;
  };
}

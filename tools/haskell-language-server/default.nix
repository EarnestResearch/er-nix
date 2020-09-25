{ fetchFromGitHub
, sources
}:

{ project
, # We can't infer this, which is fine as long as we're using a hashed
  # one.  We're just overriding nix-hls' pin here so haskell.nix looks
  # it up in its own indexStateHashesPath.
  index-sha256 ? null
}:
let
  ghcVersion = project.project.pkg-set.options.compiler.nix-name.value;
  index-state = project.project.index-state;
in
import sources.nix-hls {
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

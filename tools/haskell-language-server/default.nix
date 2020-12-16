{ fetchFromGitHub
, haskell-nix
, makeWrapper
, stdenv
}:

{ ghcVersion
, sources
, index-state
, index-sha256
}:
let
  # Most of what follows is inlined https://github.com/shajra/nix-hls.
  # We tried to call it directly, but getting it to use our nixpkgs
  # proved irksome.

  planConfigFor = name: modules: {
    inherit name modules index-state index-sha256;
    configureArgs = "--disable-benchmarks";
    compiler-nix-name = ghcVersion;
  };

  allExes = pkg: pkg.components.exes;

  fromSource = name: modules:
    let
      planConfig = planConfigFor name modules // {
        src = sources'."${name}";
      };
    in
    allExes (haskell-nix.cabalProject planConfig)."${name}";

  sources' = {
    # This has a submodule, which niv doesn't yet handle.
    # Note that this also defeats nix-prefetch-git.
    # https://github.com/nmattia/niv/issues/229
    haskell-language-server =
      with sources.haskell-language-server;
      fetchFromGitHub {
        inherit owner repo rev;
        name = "haskell-language-server-with-submodules-src";
        sha256 = "0w37792wkq4ys7afgali4jg1kwgkbpk8q0y95fd2j1vgpk0pndlr";
        fetchSubmodules = true;
      };
  };

  build = fromSource "haskell-language-server"
    [{ enableSeparateDataOutput = true; }];

  trueVersion = {
    "ghc861" = "8.6.1";
    "ghc862" = "8.6.2";
    "ghc863" = "8.6.3";
    "ghc864" = "8.6.4";
    "ghc865" = "8.6.5";
    "ghc881" = "8.8.1";
    "ghc882" = "8.8.2";
    "ghc883" = "8.8.3";
    "ghc884" = "8.8.4";
    "ghc8101" = "8.10.1";
    "ghc8102" = "8.10.2";
  }."${ghcVersion}" or (throw "unsupported GHC Version: ${ghcVersion}");

  longDesc = suffix: ''
    Haskell Language Server (HLS) is the latest attempt make an IDE-like
    experience for Haskell that's compatible with different editors. HLS
    implements Microsoft's Language Server Protocol (LSP). With this
    approach, a background service is launched for a project that answers
    questions needed by an editor for common IDE features.

    Note that you need a version of HLS compiled specifically for the GHC
    compiler used by your project.  If you have multiple versions of GHC and
    HLS installed in your path, then a provided wrapper can be used to
    select the right one for the version of GHC used by your project.

    ${suffix}
  '';

  hls = build.haskell-language-server.overrideAttrs (
    old: {
      name = "haskell-language-server-${ghcVersion}";
      meta = old.meta // {
        description =
          "Haskell Language Server (HLS) for GHC ${trueVersion}";
        longDescription = ''
          This package provides the server executable compiled against
          ${trueVersion}.  It has the name original name of
          "haskell-language-server," which may clash with versions compiled for
          other compilers.
        '';
      };
    }
  );

  hls-renamed = stdenv.mkDerivation {
    name = "haskell-language-server-${ghcVersion}-renamed";
    version = hls.version;
    phases = [ "installPhase" ];
    nativeBuildInputs = [ makeWrapper ];
    installPhase = ''
      mkdir --parents $out/bin
      makeWrapper \
          "${hls}/bin/haskell-language-server" \
          "$out/bin/haskell-language-server-${trueVersion}"
    '';
    meta = hls.meta // {
      description =
        "Haskell Language Server (HLS) for GHC ${trueVersion}, renamed binary";
      longDescription = ''
        This package provides the server executable compiled against
        ${trueVersion}.  The binary has been renamed from
        "haskell-language-server" to "haskell-language-server-${ghcVersion}" to
        allow Nix to install multiple versions to the same profile for those
        that wish to use the HLS wrapper.
      '';
    };
  };

  hls-wrapper = build.haskell-language-server-wrapper.overrideAttrs (
    old: {
      name = "haskell-language-server-${ghcVersion}-wrapper";
      meta = old.meta // {
        description = "Haskell Language Server (HLS) wrapper";
        longDescription = "This package provides the server wrapper.";
      };
    }
  );
in
{
  inherit
    hls
    hls-wrapper
    hls-renamed
    ;
}

final: prev:

let
  inherit (final) lib;

in
{
  haskell-nix = prev.haskell-nix // {

    custom-tools = {
      ghcide.object-code = args:
        (
          final.haskell-nix.cabalProject (
            args // {
              name = "ghcide";
              src = final.fetchFromGitHub {
                owner = "mpickering";
                repo = "ghcide";
                rev = "ffcdb684773aeaf8d0a699ea16e747ad2b58cafd";
                sha256 = "1qr798axm4wyhipbbhzknbax5kqjybb3ahb1zb9fw2vmka6j3ki2";
              };
              modules = [
                (
                  { config, ... }: {
                    packages.ghcide.configureFlags = lib.optional (!final.stdenv.targetPlatform.isMusl)
                      "--enable-executable-dynamic";
                    nonReinstallablePkgs = [
                      "Cabal"
                      "array"
                      "base"
                      "binary"
                      "bytestring"
                      "containers"
                      "deepseq"
                      "directory"
                      "filepath"
                      "ghc"
                      "ghc-boot"
                      "ghc-boot-th"
                      "ghc-compact"
                      "ghc-heap"
                      "ghc-prim"
                      "ghci"
                      "haskeline"
                      "hpc"
                      "integer-gmp"
                      "libiserv"
                      "mtl"
                      "parsec"
                      "pretty"
                      "process"
                      "rts"
                      "stm"
                      "template-haskell"
                      "terminfo"
                      "text"
                      "time"
                      "transformers"
                      "unix"
                      "xhtml"
                    ];
                  }
                )
              ];
              pkg-def-extras = [
                (
                  hackage: {
                    packages = {
                      "alex" = (((hackage.alex)."3.2.5").revisions).default;
                      "happy" = (((hackage.happy)."1.19.12").revisions).default;
                    };
                  }
                )
              ];
            }
          )
        ).ghcide.components.exes.ghcide;
    };
  };
}

let
  sources = import ./nix/sources.nix;
  haskell-nix = import sources.haskell-nix {};
in
rec {
  # A pinned version of nixpkgs, widely used and hopefully well cached.
  defaultNixpkgs = import sources.nixpkgs;

  # A package set from `defaultNixpkgs`, merging `args` into `nixpkgsArgs`.
  # Convenient for introducing a local overlay.
  #
  #   myOverlay = self: super: { ... };
  #   erNix.pkgsWith {
  #     overlays = erNix.overlays ++ [ myOverlay ];
  #   };
  pkgsWith = args: defaultNixpkgs (nixpkgsArgs // args);

  # A package set for the specified system, based on `defaultNixpkgs` with all overlays applied.
  pkgsForSystem = system: pkgsWith { inherit system; };

  # `pkgsForSystem` for the current system.
  pkgs = pkgsForSystem builtins.currentSystem;

  # Args to apply to any nixpkgs to generate a package set with the overlays.
  nixpkgsArgs = haskell-nix.nixpkgsArgs // { inherit overlays; };

  # All the haskell.nix overlays plus all the er-nix overlays.
  overlays = haskell-nix.overlays ++ (import ./overlays);

  inherit (import sources.niv {}) niv;

  tools = rec {
    haskell-language-server =
      { ... }@args: pkgs.lib.warn "haskell-language-server is deprecated.  Install haskellLanguageServersFor(ghcVersions) to your environment."
        pkgs.callPackage ./tools/haskell-language-server/hls.nix
        {}
        ({ inherit sources; } // args);

    haskell-language-servers = haskellLanguageServersFor [ "ghc865" "ghc884" ];

    haskellLanguageServersFor = ghcVersions:
      pkgs.callPackage ./tools/haskell-language-server/hlsFor.nix {} {
        inherit ghcVersions sources;
      };

    hopenpgp-tools = (pkgs.haskell-nix.hackage-package {
      name = "hopenpgp-tools";
      version = "0.23.3";
      compiler-nix-name = "ghc884";
    }).components.exes;
  };
}

self: super:
{
  haskell-nix = super.haskell-nix // (
    {
      defaultModules = super.haskell-nix.defaultModules ++ [
        (
          { pkgs, buildModules, config, lib, ... }:
            {
              packages.x509-system.patches = pkgs.lib.optionals pkgs.stdenv.hostPlatform.isDarwin [ ./patches/x509-system.patch ];
            }
        )
      ];
    }
  );
}

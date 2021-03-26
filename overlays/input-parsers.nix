self: super:
{
  haskell-nix = super.haskell-nix // (
    {
      defaultModules = super.haskell-nix.defaultModules ++ [
        (
          { pkgs, buildModules, config, lib, ... }:
            {
              packages.input-parsers.patches = [ ./patches/input-parsers.patch ];
            }
        )
      ];
    }
  );
}

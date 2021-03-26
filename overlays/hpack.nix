self: super:
{
  haskell = super.haskell // {
    packages = super.haskell.packages // {
      ghc865 = super.haskell.packages.ghc865.override {
        overrides = hself: hsuper: {
          hpack_0_34 = self.haskell-nix.tool "ghc865" "hpack" "0.34.3";
        };
      };
    };
  };
}

_: super: {
  haskell-nix = super.haskell-nix // {
    stackageSourceJSON = ../pins/default-stackage.json;
  };
}

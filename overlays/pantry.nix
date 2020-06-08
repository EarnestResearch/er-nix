final: prev:
{
  haskell-nix = prev.haskell-nix // {
    hackage = prev.haskell-nix.hackage // {
      pantry = builtins.removeAttrs prev.haskell-nix.hackage.pantry [ "0.5.0.0" ];
    };
  };
}

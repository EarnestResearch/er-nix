{ callPackage }:

{ project
, # We can't infer this, which is fine as long as we're using a hashed one.
  # We're just overriding nix-hls' pin here so haskell.nix looks
  # it up in its own indexStateHashesPath.
  index-sha256 ? null
, sources
}:
let
  hlsPkgs = callPackage ./. {} {
    inherit sources index-sha256;
    ghcVersion = project.project.pkg-set.options.compiler.nix-name.value;
    index-state =
      if builtins.hasAttr "index-state" project
      then project.index-state
      else null;
  };
in
{
  inherit (hlsPkgs) hls-wrapper hls-renamed;
}

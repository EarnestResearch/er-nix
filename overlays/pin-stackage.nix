self: super:

let
  sources = import ../nix/sources.nix;
  stackage = sources.stackage;
  stackageSourceJSON = self.writeText "stackage-source.json" (
    builtins.toJSON {
      inherit (stackage) rev sha256;
      url = "https://github.com/${stackage.owner}/${stackage.repo}";
      fetchSubmodules = false;
      # We don't have, or need, the date
    }
  );
in
{
  haskell-nix = super.haskell-nix // {
    inherit stackageSourceJSON;
  };
}

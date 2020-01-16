let
  sources = import ../nix/sources.nix;
  all-hies = import sources.all-hies {};

in
all-hies.selection { selector = p: { inherit (p) ghc865; }; }

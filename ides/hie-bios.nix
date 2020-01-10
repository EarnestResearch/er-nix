let
  all-hies = (import ../sources).all-hies {};

in
all-hies.bios.selection { selector = p: { inherit (p) ghc865; }; }

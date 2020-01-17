let
  bootstrap = import ./.;
  pkgs = with bootstrap; defaultNixpkgs (nixpkgsArgs);
in
  with pkgs; mkShell {
    inherit (earnestresearch.pre-commit-check) shellHook;
    buildInputs = [
      bootstrap.niv
      nixpkgs-fmt
    ];
  }

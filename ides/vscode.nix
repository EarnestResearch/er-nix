{ pkgs, additionalExtensions ? [], ... }:

let
  hie = import ./hie.nix;
  dhall-lsp-server = (import ./dhall-lsp-server.nix) { inherit (pkgs) runCommand; };
  vscodeOverlay = pkgs.vscode-with-extensions.override {
    vscodeExtensions = with pkgs.vscode-extensions; [
      alanz.vscode-hie-server
      justusadam.language-haskell
      bbenoist.Nix
    ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      {
        name = "vscode-dhall-lsp-server";
        publisher = "panaeon";
        version = "0.0.4";
        sha256 = "0ws2ysra5iifhqd2zf7zy2kcymacr5ylcmi1i1zqljkpqqmvnv5q";
      }
      {
        name = "dhall-lang";
        publisher = "panaeon";
        version = "0.0.4";
        sha256 = "0qcxasjlhqvl5zyf7w9fjx696gnianx7c959g2wssnwyxh7d14ka";
      }
      {
        name = "hoogle-vscode";
        publisher = "jcanero";
        version = "0.0.7";
        sha256 = "0ndapfrv3j82792hws7b3zki76m2s1bfh9dss1xjgcal1aqajka1";
      }
    ] ++ additionalExtensions;

  };
  inherit (pkgs.vscode) executableName;
  wrappedPkgVersion = pkgs.lib.getVersion vscodeOverlay;
  wrappedPkgName = pkgs.lib.removeSuffix "-${wrappedPkgVersion}" vscodeOverlay.name;

in
pkgs.runCommand "${wrappedPkgName}-with-extensions-with-deps-${wrappedPkgVersion}" {
  buildInputs = [ vscodeOverlay pkgs.makeWrapper ];
  dontPatchELF = true;
  dontStrip = true;
  meta = vscodeOverlay.meta;
} ''
  makeWrapper "${vscodeOverlay}/bin/${executableName}" "$out/bin/${executableName}" --prefix PATH : ${pkgs.lib.makeBinPath [ hie dhall-lsp-server pkgs.stack pkgs.cabal-install ] }
''

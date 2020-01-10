{ runCommand }:
runCommand "dhall-lsp-server" {
  tarball = builtins.fetchTarball {
    name = "dhall-lsp-server-1.0.3-archive";
    url = https://github.com/dhall-lang/dhall-haskell/releases/download/1.28.0/dhall-lsp-server-1.0.3-x86_64-macos.tar.bz2;
    sha256 = "17plcy25if6vpxkgi2f9g0zsqwzp5d5wqpkr0g1qjklnaiv8szd7";
  };
}
  ''
    mkdir -p $out/bin
    cp  $tarball/* $out/bin
  ''

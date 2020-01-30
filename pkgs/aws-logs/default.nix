{ fetchurl, lib, stdenv }:

let
  version = "1.4";
  urlTemplate = arch: "https://github.com/andreyk0/aws-logs/releases/download/v1.4/aws-logs-${arch}";
  sources = {
    x86_64-linux = fetchurl {
      url = urlTemplate "Linux-x86_64";
      sha256 = "1bmy1265xa9lqprl4xgywpygaxmiz3lh1mr2s0pnwxmvbmfl953q";
    };
    x86_64-darwin = fetchurl {
      url = urlTemplate "Darwin-x86_64";
      sha256 = "009032ic05bjdnlkrp54b2vlaccbqd3n5xhg0qm6h3pa2qfprxh6";
    };
  };
  unsupported = throw "Platform ${stdenv.hostPlatform.system} unsupported for aws-logs";
in
stdenv.mkDerivation rec {
  name = "aws-logs-${version}";
  src = lib.attrByPath [ stdenv.hostPlatform.system ] unsupported sources;

  dontUnpack = true;
  dontFixup = true;

  installPhase = ''
    mkdir -p $out/bin
    install -m 755 ${src} $out/bin/aws-logs
  '';
}

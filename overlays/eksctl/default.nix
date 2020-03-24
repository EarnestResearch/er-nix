{ runCommand, stdenv }:

let
  unsupported = throw "Unsupported system: ${stdenv.hostPlatform.system}";
  systemParams = {
    x86_64-linux = {
      arch = "Linux_amd64";
      sha256 = "14vxza3q7lv4r4f3kqjgjaxb13bzfvhnbg8xiyyisyzsifmxnm1c";
    };
    x86_64-darwin = {
      arch = "Darwin_amd64";
      sha256 = "031alxb7i0mlycf6215m8lsshp4xf7djgh2pvsk5i19wg1fs9rx7";
    };
  }.${stdenv.hostPlatform.system} or unsupported;
in
  with systemParams; runCommand "eksctl-0.15.0" {
    tarball = builtins.fetchurl {
      name = "eksctl-0.15.0-archive";
      url = "https://github.com/weaveworks/eksctl/releases/download/0.15.0/eksctl_${arch}.tar.gz";
      inherit sha256;
    };
  }
    ''
      mkdir -p $out/bin
      cd $out/bin
      tar xvfz $tarball
    ''

{ fetchurl, lib, stdenv, unixODBC }:

let
  version = "2.22.3";
  sources = {
    x86_64-linux = fetchurl {
      url = "https://sfc-repo.snowflakecomputing.com/odbc/linux/latest/snowflake_linux_x8664_odbc-${version}.tgz";
      sha256 = "65fceb95a4e44e25522801097b390bb4ec985248e8ceda55db08ee5620aac409";
    };
  };
  unsupported = throw "Platform ${stdenv.hostPlatform.system} unsupported for aws-logs";
in
stdenv.mkDerivation rec {
  name = "snowflake-odbc-${version}";
  src = lib.attrByPath [ stdenv.hostPlatform.system ] unsupported sources;

  buildInputs = [
    unixODBC
  ];

  installPhase = ''
    for d in ErrorMessages include lib; do
      mkdir -p $out/$d
      cp -rp $d $out
    done

    mkdir $out/conf
    for f in odbcinst.ini odbc.ini; do
      sed -e "s+/path/to/your/libSnowflake.so+$out/lib/libSnowflake.so+" conf/$f > $out/conf/$f
    done

    sed -e "s+/path/to/ErrorMessages+$out/ErrorMessages+" \
        -e "s+/path/to/cacert.pem+$out/lib/cacert.pem+" \
        -e "s+ODBCInstLib=/usr/lib64+ODBCInstLib=${unixODBC}/lib+" \
        conf/unixodbc.snowflake.ini > $out/lib/simba.snowflake.ini
  '';
}

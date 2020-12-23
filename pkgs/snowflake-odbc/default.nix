{ fetchurl, lib, stdenv, unixODBC, undmg, xar, cpio }:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "snowflake-odbc";
  version = {
    x86_64-darwin = "2.22.3";
    x86_64-linux = "2.22.3";
  }.${system} or throwSystem;
  name = "${pname}-${version}";

  sha256 = {
    x86_64-darwin = "c7318be7631d8480340b49fd9ad175dc8925c56ffad030269dbe701944e11bf5";
    x86_64-linux = "65fceb95a4e44e25522801097b390bb4ec985248e8ceda55db08ee5620aac409";
  }.${system} or throwSystem;

  url = {
    x86_64-darwin = "https://sfc-repo.snowflakecomputing.com/odbc/mac64/latest/snowflake_odbc_mac-${version}.dmg";
    x86_64-linux = "https://sfc-repo.snowflakecomputing.com/odbc/linux/latest/snowflake_linux_x8664_odbc-${version}.tgz";
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "Snowflake ODBC drivers";
    homepage = "https://docs.snowflake.com/en/index.html";
    downloadPage = "https://docs.snowflake.com/en/user-guide/odbc-download.html";
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
  src = fetchurl {
    inherit url sha256;
  };
  buildInputs = [ unixODBC ];

  installPhase = ''
    for d in ErrorMessages include lib; do
      mkdir -p $out/$d
      cp -rp $d $out
    done
    mkdir $out/conf
  '';

  linux = stdenv.mkDerivation rec {
    inherit name pname installPhase version buildInputs src meta;
    fixupPhase = ''
      for f in odbcinst.ini odbc.ini; do
        sed -e "s+/path/to/your/libSnowflake.so+$out/lib/libSnowflake.so+" conf/$f > $out/conf/$f
      done

      sed -e "s+/path/to/ErrorMessages+$out/ErrorMessages+" \
          -e "s+/path/to/cacert.pem+$out/lib/cacert.pem+" \
          -e "s+ODBCInstLib=/usr/lib64+ODBCInstLib=${unixODBC}/lib+" \
          conf/unixodbc.snowflake.ini > $out/lib/simba.snowflake.ini
    '';
  };

  darwin = stdenv.mkDerivation rec {
    inherit name pname installPhase version buildInputs src meta;

    nativeBuildInputs = [ undmg xar cpio ];

    unpackPhase = stdenv.lib.optionalString stdenv.isDarwin ''
      undmg $src
      xar -xf snowflakeODBC.pkg
      zcat Payload | cpio -i
    '';

    fixupPhase = ''
      for f in odbcinst.ini odbc.ini; do
        sed -e "s+/opt/snowflake/snowflakeodbc+$out+" Setup/$f > $out/conf/$f
      done

      sed -e "s+/opt/snowflake/snowflakeodbc+$out+" \
          -e "s+ODBCInstLib=libodbcinst.dylib+ODBCInstLib=${unixODBC}/lib/libodbcinst.dylib+" \
          -i $out/lib/universal/simba.snowflake.ini
    '';
  };
in
if stdenv.isDarwin
then darwin
else linux

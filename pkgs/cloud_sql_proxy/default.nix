{ fetchurl, lib, stdenv }:
let
  inherit (stdenv.hostPlatform) system;
  throwSystem = throw "Unsupported system: ${system}";

  pname = "cloud_sql_proxy";
  version = {
    x86_64-darwin = "1.19.1";
    x86_64-linux = "1.19.1";
  }.${system} or throwSystem;
  name = "${pname}-${version}";

  sha256 = {
    x86_64-darwin = "a77e311f6c7bb1249022f23111c45181aced59db7af05d736a532f0b44838968";
    x86_64-linux = "0fe56437162cabed9d4cc382cbcc16a93dc024f8598a3c6698f040f2d8505264";
  }.${system} or throwSystem;

  url = {
    # Sadly, google doesn't seem to make stable versioned URLs available, and I'm
    # not sure the version that can be built from github is that same one that can
    # be downloaded from google.com
    x86_64-darwin = "https://dl.google.com/cloudsql/cloud_sql_proxy.darwin.amd64";
    x86_64-linux = "https://dl.google.com/cloudsql/cloud_sql_proxy.linux.amd64";
  }.${system} or throwSystem;

  meta = with stdenv.lib; {
    description = "Snowflake ODBC drivers";
    homepage = "https://cloud.google.com/sql/docs/postgres/sql-proxy";
    downloadPage = "https://cloud.google.com/sql/docs/postgres/sql-proxy#install";
    changelog = "https://github.com/GoogleCloudPlatform/cloudsql-proxy/blob/master/CHANGELOG.md";
    platforms = [
      "x86_64-darwin"
      "x86_64-linux"
    ];
  };
  src = fetchurl {
    inherit url sha256;
    downloadToTemp = true;
    postFetch = ''
      install -D $downloadedFile $out/cloud_sql_proxy
    '';
  };
in
stdenv.mkDerivation {
  inherit name meta src;
}

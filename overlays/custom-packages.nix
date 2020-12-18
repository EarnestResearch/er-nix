self: super:

{
  aws-logs = self.callPackage ../pkgs/aws-logs {};
  okta-aws-login = import ../pkgs/okta-aws-login;
  skopeo = self.callPackage ../pkgs/skopeo {};
  snowflake-odbc = self.callPackage ../pkgs/snowflake-odbc {};
}

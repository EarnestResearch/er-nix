self: super:

{
  aws-logs = self.callPackage ../pkgs/aws-logs {};
  okta-aws-login = self.callPackage ../pkgs/okta-aws-login {};
}

let
  sources = import ../../nix/sources.nix;
  oktaAwsLogin = import sources.okta-aws-login;
in
(oktaAwsLogin {}).okta-aws-login.components.exes.okta-aws-login.out

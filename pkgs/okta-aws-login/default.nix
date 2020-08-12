let
  oktaAwsLogin = import (
    builtins.fetchGit {
      url = "https://github.com/EarnestResearch/okta-aws-login.git";
      ref = "refs/heads/master";
      rev = "9bedc99e8abf7fab22738c5e2ccc8935b6a9f391";
    }
  );

in
(oktaAwsLogin {}).okta-aws-login.components.exes.okta-aws-login.out

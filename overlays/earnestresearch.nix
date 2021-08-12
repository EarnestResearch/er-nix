self: super:

let
  sources = import ../nix/sources.nix;
  pre-commit-hooks = import sources.pre-commit-hooks;
in
{
  earnestresearch = {
    upload_docker_to_aws =
      super.callPackage ../applications/upload_docker_to_aws { };

    lib = {
      docker.upload-to-aws = super.callPackage ../lib/docker/upload-to-aws;
    };

    pre-commit-check = import ../pre-commit-check;
  };

  inherit (pre-commit-hooks) hlint nixpkgs-fmt ormolu;

  inherit pre-commit-hooks;
}

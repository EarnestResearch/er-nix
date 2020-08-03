/* Utility functions to setup environment in our cabal projects

   Example call from your shell.nix:

    hsPkgs = import ./default.nix { inherit pkgs; };
    cabalProject = pkgs.earnestresearch.lib.cabal.project hsPkgs "your-project-name";
*/
{ writeScriptBin, hsPkgs, projectName }:

let
  earnestProject = builtins.getAttr projectName hsPkgs;
  ghcVersion = earnestProject.project.pkg-set.config.ghc.package.version;
  cabalSystem = builtins.replaceStrings [ "darwin" ] [ "osx" ] builtins.currentSystem; # cabal's convention

  # See notes about LD_LIBRARY_PATH below
  localLdLibPath = "$(pwd)/dist-newstyle/build/${cabalSystem}/ghc-${ghcVersion}/${projectName}-${earnestProject.components.library.version}/noopt/build";

  # Platform dependent runtime linker config to allow for fully shared (including haskell libs) builds
  # during development (faster build times)
  ldEnvVar = if builtins.currentSystem == "x86_64-darwin"
  then "DYLD_LIBRARY_PATH=${localLdLibPath}"
  else "LD_LIBRARY_PATH=${localLdLibPath}";

  # Convenient access to project's build artifacts.
  # Running them via cabal (as opposed to linking to results directly)
  # has the advantages of not caring about the actual paths (cabal doesn't have
  # "config export" functionality) as well as making sure that people won't run
  # code that doesn't include their local changes.
  # Note that if cabal is properly configured than this does NOT incur needless recompilation.
  # This should also be backwards compatible with the "stack" builds as this only triggers
  # in the nix shell environment and results stay out of project's directory.
  #
  # Note that exporting LD path is not enough on macos, doesn't propagate to forked processes:
  # https://www.mathworks.com/matlabcentral/answers/473971-how-do-i-configure-the-ld_library_path-on-linux-and-dyld_library_path-on-mac-os-x-to-point-to-mcr
  runAppScript = tool: writeScriptBin tool ''
    #!/bin/sh
    ${ldEnvVar} cabal new-run ${tool} -- "$@"
  '';

  # Shell scripts to run all apps defined within a project via cabal new-run
  projectApps = (map runAppScript (builtins.attrNames (earnestProject.components.exes)));
in
{
  cabalSystem = cabalSystem;
  ldEnvVar = ldEnvVar;
  runAppScript = runAppScript;
  projectApps = projectApps;
}

{ stdenv
, lib
, buildGoModule
, fetchFromGitHub
, runCommand
, gpgme
, lvm2
, btrfs-progs
, pkg-config
, go-md2man
, installShellFiles
, makeWrapper
, fuse-overlayfs
, nixosTests
}:

buildGoModule rec {
  pname = "skopeo";
  version = "1.1.1.0";

  src = builtins.fetchGit {
    url = "https://github.com/containers/skopeo.git";
    ref = "refs/heads/master";
    rev = "c052ed7ec8622187679ff067d795acbdd45e4530";
  };

  patches = [ ../../overlays/patches/skopeo.patch ];

  outputs = [ "out" "man" ];

  vendorSha256 = null;

  nativeBuildInputs = [ pkg-config go-md2man installShellFiles makeWrapper ];

  buildInputs = [ gpgme ]
  ++ lib.optionals stdenv.isLinux [ lvm2 btrfs-progs ];

  buildPhase = ''
    patchShebangs .
    make bin/skopeo
  '';

  installPhase = ''
    make install-binary PREFIX=$out
    make install-docs MANINSTALLDIR="$man/share/man"
    installShellCompletion --bash completions/bash/skopeo
  '';

  postInstall = lib.optionals stdenv.isLinux ''
    wrapProgram $out/bin/skopeo \
      --prefix PATH : ${lib.makeBinPath [ fuse-overlayfs ]}
  '';

  passthru.tests.docker-tools = nixosTests.docker-tools;

  meta = with lib; {
    description = "A command line utility for various operations on container images and image repositories";
    homepage = "https://github.com/containers/skopeo";
    maintainers = with maintainers; [ lewo ] ++ teams.podman.members;
    license = licenses.asl20;
  };
}

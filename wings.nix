{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pterodactyl-wings";
  version = "1.5.6";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-SzN31Cl63f4iduGJMJ4/H3jggdME7UX1fTriwqEbsxM=";
  };

  vendorSha256 = "sha256-nPRBN+wmj9dszYMAGkMsk/sENK7xWae306BOQbDaa2Q=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}

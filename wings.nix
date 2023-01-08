{ lib, buildGo118Module, fetchFromGitHub }:

buildGo118Module rec {
  pname = "pterodactyl-wings";
  version = "1.11.0";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-JiBhx56LbyShFX3igP+GgougWQwUP98PJzCU+cqfdF4=";
  };

  vendorSha256 = "sha256-ccffR3iHY/GTEHQKm4011mfa0irKyv0/umiaf1GOP5Y=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}

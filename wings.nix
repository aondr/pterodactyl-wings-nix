{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pterodactyl-wings";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-I3qw9r7mGuRy6vFB5v1XAhBX1c0fFc9djpCnog94EW0=";
  };

  vendorSha256 = "sha256-c3BCMLjb/oSep5JAve5To8Q1WU1zLOnQWmiUL8xRCpU=";
  subPackages = [ "." ];
}

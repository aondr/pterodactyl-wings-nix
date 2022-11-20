{ lib, buildGo118Module, fetchFromGitHub }:

buildGo118Module rec {
  pname = "pterodactyl-wings";
  version = "1.7.2";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-TZVALOXOFZg9Dau76sXAl1+xucM9HHomL6OnZ1fBXZQ=";
  };

  vendorSha256 = "sha256-3/gCc7akZ+rDugqf2BhwSrPbRnCej9k0WWTc5/NLDmY=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}

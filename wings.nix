{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pterodactyl-wings";
  version = "1.4.5";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-0h9tarl7pRpyA6LqfJFKIHBRoSvHsKH5jWntMcjgvB8=";
  };

  vendorSha256 = "sha256-u8jrp/Rkq0lANIcc2nRF1mvCuHaKeb2BsabBmYUnHt4=";
  subPackages = [ "." ];
}

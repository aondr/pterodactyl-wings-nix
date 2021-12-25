{ lib, buildGoModule, fetchFromGitHub }:

buildGoModule rec {
  pname = "pterodactyl-wings";
  version = "1.5.3";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-2Tdx37/rojpj2d9Pm7KV6MFNveYmEqbP94HaJuwT4O4=";
  };

  vendorSha256 = "sha256-QE5nBhWRMJRyYbipviDjVaZmHorVQrDhNHahGKSvfa0=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}

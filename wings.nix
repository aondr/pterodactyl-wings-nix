{ lib, buildGo118Module, fetchFromGitHub }:

buildGo118Module rec {
  pname = "pterodactyl-wings";
  version = "1.6.1";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-erqt+/2RTQOOwIyg+YzFNLYTVn8OHQ9tZ7tN4rwDLHs=";
  };

  vendorSha256 = "sha256-JqIeBGTtgpyUrKySEADt4oy5FgVzheBOIgpVQVxnzsE=";
  subPackages = [ "." ];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}

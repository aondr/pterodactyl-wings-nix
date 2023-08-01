{
  lib,
  buildGo120Module,
  fetchFromGitHub,
}:
buildGo120Module rec {
  pname = "pterodactyl-wings";
  version = "v1.11.7";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "${version}";
    sha256 = "sha256-MWeUSlJsKNnV/oZotIne3KN3j+fjKNfPJQb+DbhNYLk=";
  };

  vendorSha256 = "sha256-3jJQQEb2N28dhXJg5knzZgfnwXUOqnouRvedpTY23jw=";
  subPackages = ["."];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];
}

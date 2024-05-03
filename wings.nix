{
  lib,
  buildGo121Module,
  fetchFromGitHub,
}:
buildGo121Module rec {
  pname = "pterodactyl-wings";
  version = "1.11.12";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-DFUnT1B2t8waiV64n4fWCPIiIyoaPuRwOEfWDR71je4=";
  };

  vendorHash = "sha256-eWfQE9cQ7zIkITWwnVu9Sf9vVFjkQih/ZW77d6p/Iw0=";
  subPackages = ["."];

  ldflags = [
    "-X github.com/pterodactyl/wings/system.Version=${version}"
  ];

  meta = with lib; {
    description = " The server control plane for Pterodactyl Panel. Written from the ground-up with security, speed, and stability in mind.";
    homepage = "https://github.com/pterodactyl/wings";
    license = licenses.mit;
    mainProgram = "wings";
    changelog = "https://github.com/pterodactyl/wings/releases/tag/v${version}";
    platforms = platforms.linux;
  };
}

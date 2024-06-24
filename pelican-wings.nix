{
  lib,
  buildGo121Module,
  fetchFromGitHub,
}:
buildGo121Module rec {
  pname = "pelican-wings";
  version = "1.0.0-beta3";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-sNmiOpgwG4Qx6vVFdj2zr/4LFrLCNpyVFq83gXQoBOM=";
  };

  vendorHash = "sha256-M7ymgLdYbQ4ejmO4xPBKtXHVhv8dJvE/I+exedCyyL8=";
  subPackages = ["."];

  ldflags = [
    "-X github.com/pelican-dev/wings/system.Version=${version}"
  ];

  meta = with lib; {
    description = "The server control plane for Pelican Panel. Written from the ground-up with security, speed, and stability in mind";
    homepage = "https://github.com/pelican-dev/wings";
    license = licenses.mit;
    mainProgram = "wings";
    changelog = "https://github.com/pelican-dev/wings/releases/tag/v${version}";
    platforms = platforms.linux;
  };
}

{
  lib,
  buildGo121Module,
  fetchFromGitHub,
}:
buildGo121Module rec {
  pname = "pterodactyl-wings";
  version = "v1.11.9";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "${version}";
    sha256 = "sha256-GyaGwC7X/qpyeCoE6k2Ljo1PeaGVWYWEC5idNBJBVik=";
  };

  vendorHash = "sha256-LR4JuV73BWhXI97HGNH93Hd5NMU9PD84Rqfz4GOJzUs=";
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

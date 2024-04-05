{
  lib,
  buildGo121Module,
  fetchFromGitHub,
}:
buildGo121Module rec {
  pname = "pterodactyl-wings";
  version = "1.11.10";

  src = fetchFromGitHub {
    owner = "pterodactyl";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-EOkHi+x4ciODyHPPx7766IEh8XGLHY4Ng1N/iq2mgJI=";
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

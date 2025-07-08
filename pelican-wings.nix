{
  lib,
  buildGo123Module,
  fetchFromGitHub,
}:
buildGo123Module rec {
  pname = "pelican-wings";
  version = "1.0.0-beta14";

  src = fetchFromGitHub {
    owner = "pelican-dev";
    repo = "wings";
    rev = "v${version}";
    sha256 = "sha256-SDPHngoVp1k5vAzyMdCpeTtbkthtLxwazZPUD5Y2+KI=";
  };

  vendorHash = "sha256-a4FmIFd9CcvfXn8+qHAvROxmQCsOGjm/5a+tm4SSmzw=";
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

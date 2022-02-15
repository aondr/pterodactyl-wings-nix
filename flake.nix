{
  description = "Pterodactyl Wings";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.docker-tools.url = "github:ZentriaMC/docker-tools";

  outputs = { self, nixpkgs, flake-utils, docker-tools }:
    let
      supportedSystems = [
        "aarch64-linux"
        "x86_64-linux"
      ];
    in
    flake-utils.lib.eachSystem supportedSystems (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages.pterodactyl-wings = pkgs.callPackage ./wings.nix { };
        packages.dockerImage = pkgs.callPackage ./wings-docker.nix {
          inherit (self.packages.${system}) pterodactyl-wings;
          inherit (docker-tools.lib) shadowSetup dockerConfig;
        };
        defaultPackage = self.packages.${system}.pterodactyl-wings;
      });
}

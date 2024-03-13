{
  description = "Pterodactyl Wings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = {
    self,
    nixpkgs,
    flake-utils,
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
  in
    flake-utils.lib.eachSystem supportedSystems (system: let
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      packages.pterodactyl-wings = pkgs.callPackage ./wings.nix {};
      packages.default = self.packages.${system}.pterodactyl-wings;
    });
}

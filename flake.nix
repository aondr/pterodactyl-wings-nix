{
  description = "Pterodactyl Wings";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    supportedSystems = [
      "aarch64-linux"
      "x86_64-linux"
    ];
    forAllSystems = f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
  in {
    nixosModules = {
      pelican-wings = import ./module.nix self;
      default = self.nixosModules.pelican-wings;
    };
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
      	pterodactyl-wings = pkgs.callPackage ./pterodactyl-wings.nix {};
        pelican-wings = pkgs.callPackage ./pelican-wings.nix {};
        default = self.packages.${system}.pelican-wings;
      }
    );
  };
}

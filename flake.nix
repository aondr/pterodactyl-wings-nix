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
      pterodactyl-wings = import ./module.nix self;
      default = self.nixosModules.pterodactyl-wings;
    };
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        pterodactyl-wings = pkgs.callPackage ./wings.nix {};
        default = self.packages.${system}.pterodactyl-wings;
      }
    );
  };
}

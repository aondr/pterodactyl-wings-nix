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
    packages = forAllSystems (
      system: let
        pkgs = nixpkgs.legacyPackages.${system};
      in {
        pelican-wings = pkgs.callPackage ./pelican-wings.nix {};
        default = self.packages.${system}.pelican-wings;
      }
    );
  };
}

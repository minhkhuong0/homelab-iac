{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  inputs.disko.url = "github:nix-community/disko";
  inputs.disko.inputs.nixpkgs.follows = "nixpkgs";
  inputs.nixos-facter-modules.url = "github:numtide/nixos-facter-modules";

  outputs =
    {
      nixpkgs,
      disko,
      ...
    }:
    {
      # Use this for all other targets
      # nixos-anywhere --flake .#generic --generate-hardware-config nixos-generate-config ./hardware-configuration.nix <hostname>
      nixosConfigurations.bastion = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./hosts/bastion/configuration.nix
          ./hosts/bastion/hardware-configuration.nix
        ];
      };

      colmena = {
        meta = {
          nixpgs = import nixpkgs { system = "x86_64-linux"; };

          specialArgs = {
            inherit nixpkgs;
          };
        };

        "bastion" = { name, nodes, ... }: {
          deployment.targetHost = "10.42.0.114";
          deployment.targetUser = "root";
        };

        imports = [
          ./hosts/bastion/configuration.nix
        ];
      };
    };
}

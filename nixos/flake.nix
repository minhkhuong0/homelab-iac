{
  inputs = { 
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
    colmena.url = "github:zhaofengli/colmena";
  };

  outputs =
    {
      self,
      nixpkgs,
      disko,
      colmena,
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

      colmenaHive = colmena.lib.makeHive self.outputs.colmena;
      colmena = {
        meta = {
          nixpkgs = import nixpkgs { system = "x86_64-linux"; };

          specialArgs = {
            inherit nixpkgs disko;
          };
        };

        bastion = { name, nodes, ... }: {
          deployment.targetHost = "10.42.0.2";
          deployment.targetUser = "root";

          imports = [
            disko.nixosModules.disko
            ./hosts/bastion/configuration.nix
          ];
        };

      };
    };
}

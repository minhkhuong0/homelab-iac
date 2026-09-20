{
  modulesPath,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;

  networking = {
    interfaces.enp6s0.ipv4.addresses = [
      {
        address = "10.42.0.2";
        prefixLength = 24;
      }
    ];
    defaultGateway = "10.42.0.1";
    useDHCP = false;
    hostName = "bastion";

    firewall.allowedUDPPorts = [ 53 ];
  };

  environment.systemPackages = with pkgs; map lib.lowPrio [
    curl
    git
    wget
    dig
    vim
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQ0V3fwQjXLr6guvAVp8Wg4b0MfyUVwtkDeVqmUOzvt homelab-terraform"
  ];

  system.stateVersion = "26.05";

  services = {
    unbound = {
      enable = true;

      settings.server = {
        interface = [ "10.42.0.2" "127.0.0.1" ];
        access-control = [ "10.42.0.0/24 allow" ];
      };
    };
  };
}

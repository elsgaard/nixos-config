{ config, lib, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot";

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  networking.hostName = "nixos-2"; # Define your hostname.

  # Set your time zone.
  time.timeZone = "Europe/Copenhagen";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_TIME = "da_DK.UTF-8";
    LC_MONETARY = "da_DK.UTF-8";
    LC_MEASUREMENT = "da_DK.UTF-8";
  };

  console.keyMap = "dk";
  services.xserver.xkb.layout = "dk";

  # Define a user account. Don't forget to set a password with ‘passwd’.
   users.users.admin = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
     initialHashedPassword = "";
     openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeqZmlYFxsg1BqomySG+hRdJLcM3Q0YqGf13okIvzO4 eddsa-key-20260207" ];
     packages = with pkgs; [
       tree
     ];
   };

  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     jdk25
     git
   ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "25.05"; # Did you read the comment?

}

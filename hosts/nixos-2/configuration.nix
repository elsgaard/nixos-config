{ config, lib, pkgs, ... }:

{
  imports = [
    # Hardware scan results
    ./hardware-configuration.nix
  ];

  ############################################################
  # Boot
  ############################################################

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi = {
    canTouchEfiVariables = true;
    efiSysMountPoint = "/boot";
  };

  ############################################################
  # Memory / Swap
  ############################################################

  zramSwap = {
    enable = true;
    memoryPercent = 25;
  };

  ############################################################
  # Networking
  ############################################################

  networking = {
    hostName = "nixos-2";

    firewall = {
      enable = true;
      allowedTCPPorts = [ 22 ];
    };
  };

  ############################################################
  # Time & Locale
  ############################################################

  time.timeZone = "Europe/Copenhagen";

  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = {
      LC_TIME        = "da_DK.UTF-8";
      LC_MONETARY    = "da_DK.UTF-8";
      LC_MEASUREMENT = "da_DK.UTF-8";
    };
  };

  console.keyMap = "dk";
  services.xserver.xkb.layout = "dk";

  ############################################################
  # Users
  ############################################################

  users.users.admin = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    # Set with `passwd admin` after first login
    initialHashedPassword = "";

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKeqZmlYFxsg1BqomySG+hRdJLcM3Q0YqGf13okIvzO4 eddsa-key-20260207"
    ];

    packages = with pkgs; [
      tree
    ];
  };

  ############################################################
  # Services
  ############################################################

  services.openssh.enable = true;

  ############################################################
  # System Packages
  ############################################################

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    jdk25
  ];

  ############################################################
  # System State (Do not change after install)
  ############################################################

  system.stateVersion = "25.05";
}

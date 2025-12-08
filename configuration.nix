{ config, pkgs, lib, inputs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    ./sddm-theme.nix
    ./stylix.nix
    inputs.stylix.nixosModules.stylix
  ];

  boot.loader =
  {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };

  programs =
  {
    hyprland.enable = true;
    hyprland.xwayland.enable = true;
    zsh.enable = true;
  };

  users.users.lgalloux =
  {
    extraGroups = 
    [ 
      "wheel" "networkmanager"
      "video" "input" "seat" 
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features=["nix-command" "flakes"];
  security.sudo.extraConfig = ''Defaults !sudoedit_checkdir'';

  services =
  {
    xserver.xkb.layout = "us";
    pipewire =
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    power-profiles-daemon.enable = true;
    upower.enable = true;
  };

  console.keyMap = "us";
  fonts.packages = with pkgs; [ noto-fonts noto-fonts-color-emoji ];

  networking =
  {
    networkmanager.enable = true;
    hostName = "nixos-hypr";
  };

  services.resolved.enable = true;

  hardware =
  {
    graphics.enable = true;
    bluetooth.enable = true;
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs;
  [
    vim git
  ];

  system.stateVersion = "24.11";
}

{ config, pkgs, lib, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
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
    niri.enable = true;
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
    displayManager.sddm =
    {
      wayland.enable = true;
      enable = true;
      theme = "tokyonight-sddm";
    };
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
  fonts.packages = with pkgs; [ noto-fonts noto-fonts-emoji ];

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
    vim firefox git libsForQt5.qtgraphicaleffects
    sddm-tokyonight
  ];

  system.stateVersion = "24.11";
}

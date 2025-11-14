{ config, pkgs, ... }:
{
  imports =
  [
    ./hardware-configuration.nix
    <home-manager/nixos>
  ];

  boot.loader =
  {
    efi.canTouchEfiVariables = true;
    systemd-boot.enable = true;
    systemd-boot.configurationLimit = 8;
  };

  home-manager.users.lgalloux = import ./home.nix;
  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;

  programs.hyprland =
  {
    enable = true;
    xwayland.enable = true;
  };

  users.users.lgalloux =
  {
    extraGroups = 
    [ 
      "wheel" "networkmanager"
      "video" "input" "seat" 
    ];
    isNormalUser = true;
    initialPassword = "qwerty";
  };

  services =
  {
    xserver.xkb.layout = "us";
    displayManager.sddm.wayland.enable = true;
    displayManager.sddm.enable = true;
    displayManager.sddm.theme = "where_is_my_sddm_theme";
    pipewire =
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  i18n.defaultLocale = "fr_FR.UTF-8";
  console.keyMap = "us";
  fonts.packages = with pkgs; [ noto-fonts noto-fonts-emoji ];

  networking =
  {
    networkmanager.enable = true;
    hostName = "nixos-hypr";
  };

  hardware.graphics.enable = true;

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs;
  [
    vim firefox git
  ];

  system.stateVersion = "24.11";
}

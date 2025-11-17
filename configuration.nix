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

  programs.hyprland =
  {
    enable = true;
    xwayland.enable = true;
  };

  programs.zsh.enable = true;

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
  security.pam.services.sddm.text = lib.mkAfter
  ''
    auth optional ${pkgs.pam_gnupg}/lib/security/pam_gnupg.so store-only debug
    session optional ${pkgs.pam_gnupg}/lib/security/pam_gnupg.so debug
  '';

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

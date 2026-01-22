{ pkgs, inputs, config, ... }:
{
  imports =
  [
    /home/lgalloux/nixos/hardware-configuration.nix
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
    xwayland.enable = true;
    hyprland.xwayland.enable = true;
    steam.enable = true;
    zsh.enable = true;
  };

  users.users.lgalloux =
  {
    extraGroups = 
    [ 
      "wheel" "networkmanager"
      "video" "input" "seat"
      "libvirtd" "kvm"
    ];
    isNormalUser = true;
    shell = pkgs.zsh;
  };

  virtualisation.libvirtd.enable = true;
  nix.settings.experimental-features=["nix-command" "flakes"];
  security.sudo.extraConfig = ''Defaults !sudoedit_checkdir'';
  security.rtkit.enable = true;

  services =
  {
    xserver.xkb.layout = "us";
    xserver.videoDrivers = [ "nvidia" ];
    resolved.enable = true;
    pulseaudio.enable = false;
    flatpak.enable = true;
    pipewire =
    {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      wireplumber.enable = true;
    };
    udev.extraRules =
    ''
      KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="320f", ATTRS{idProduct}=="5055", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    '';
    snapper.configs =
    {
      home =
      {
        SUBVOLUME = "/home";  # Chemin du subvolume BTRFS à snapshoter
        ALLOW_USERS = [ "lgalloux" ];  # Lecture snapshots sans sudo
        TIMELINE_CREATE = true;
        TIMELINE_CLEANUP = true;  # Nettoyage auto
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "4";
        TIMELINE_LIMIT_MONTHLY = "3";
        CLEANUP_ALGORITHM = "timeshift";  # Stratégie de rétention
      };
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

  hardware =
  {
    nvidia =
    {
      modesetting.enable = true;
      open = true;
      powerManagement.enable = false;
      nvidiaPersistenced = true;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };
    graphics.enable = true;
    bluetooth =
    {
      enable = true;
      settings.General.ControllerMode = "bredr";
    };
  };

  time.timeZone = "Europe/Paris";

  environment.systemPackages = with pkgs;
  [
    vim git
  ];

  system.stateVersion = "24.11";
}

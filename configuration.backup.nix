# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 8;
  boot.loader.efi.canTouchEfiVariables = true;
    networking.extraHosts = ''
    127.0.0.1 lgalloux.42.fr
  '';
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Paris";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "fr_FR.UTF-8";
    LC_IDENTIFICATION = "fr_FR.UTF-8";
    LC_MEASUREMENT = "fr_FR.UTF-8";
    LC_MONETARY = "fr_FR.UTF-8";
    LC_NAME = "fr_FR.UTF-8";
    LC_NUMERIC = "fr_FR.UTF-8";
    LC_PAPER = "fr_FR.UTF-8";
    LC_TELEPHONE = "fr_FR.UTF-8";
    LC_TIME = "fr_FR.UTF-8";
  };

  nix.settings.experimental-features=["nix-command" "flakes"];
  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Activer le service Bluetooth
  hardware.bluetooth =
  {
    enable = true;
    powerOnBoot = true;
    settings =
    {
      General =
      {
        Experimental = true;
        FastConnectable = true;
      };
      Policy =
      {
        AutoEnable = true;
      };
    };
  };

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  users.groups.uinput = {};

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.lgalloux = {
    isNormalUser = true;
    description = "lgalloux";
    extraGroups = [ "networkmanager" "wheel" "docker" "network" "lp" "uinput"];
    packages = with pkgs; [
      kdePackages.kate
    #  thunderbird
    ];
    shell = pkgs.zsh;
  };

security.sudo.extraConfig = ''
  # Désactive la vérification qui empêche sudoedit de fonctionner
  # dans certains cas sur NixOS.
  Defaults !sudoedit_checkdir
'';

  # Install firefox.
  programs.firefox.enable = true;
  programs.zsh.enable = true;
  programs.zsh.ohMyZsh.enable = true;
  programs.zsh.ohMyZsh.theme = "robbyrussell";

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      registry-mirrors = [ "https://mirror.gcr.io" ];
    };
  };

  # languages.python = {
  #   enable = true;
  #   venv.enable = true;
  #   venv.requirements = lib.readFile ./requirements.txt
  # }

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
	helix valgrind clang clang-tools vim gnumake bear git cmake rr gdb xsel discord-ptb
	obsidian direnv musescore man-pages steam-run radare2
  man-pages-posix kitty nixd weylus
  ];
 
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };
  programs.ssh = {
    startAgent = true;
  };
  # List services that you want to enable:
	services = {
    	  syncthing = {
        	enable = true;
        	user = "lgalloux";
        	dataDir = "/home/lgalloux";    # Default folder for new synced folders
        	configDir = "/home/lgalloux/.config/syncthing";   # Folder for Syncthing's settings and keys
    		};
	};

  networking.firewall = {
    enable = true; # Assurez-vous que le pare-feu est bien activé
    allowedTCPPorts = [ 1701 ]; # Ouvrez le port utilisé par Weylus
  };

  # Étape 3: Créer la règle udev pour les permissions
  services.udev.extraRules = ''
    KERNEL=="uinput", MODE="0660", GROUP="uinput", OPTIONS+="static_node=uinput"
  '';

  # Étape 4 (recommandée): Forcer le chargement du module noyau
  boot.kernelModules = [ "uinput" ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?

}


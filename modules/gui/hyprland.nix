{ config, pkgs, lib, ... }:

{
  # Les paquets restent les mêmes
  home.packages = with pkgs;
  [
    wofi
    brightnessctl
  ];

  # Configuration du programme Hyprland via Home Manager
  wayland.windowManager.hyprland =
  {
      enable = true;
      xwayland.enable = true;

    extraConfig = ''
      # Moniteur
      monitor=,preferred,auto,1
      
      # Exécuter au démarrage
      exec-once = waybar
      exec-once = systemctl --user import-environment && nm-applet --indicator
      
      # Raccourcis clavier
      bind = SUPER, Return, exec, alacritty
      bind = SUPER, Q, killactive
      bind = SUPER, M, exit
      bind = SUPER, D, exec, wofi --show drun

      input {
        touchpad {
          natural_scroll = true
        }
      }

      # Contrôle de la luminosité
      bind = , XF86MonBrightnessUp, exec, brightnessctl set +5%
      bind = , XF86MonBrightnessDown, exec, brightnessctl set 5%-
      
      # Contrôle du volume
      bind = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+
      bind = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bind = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      
      # Espaces de travail
      bind = SUPER, 1, workspace, 1
      bind = SUPER, 2, workspace, 2
      bind = SUPER, 3, workspace, 3
      # ... etc
    '';
  };

  # Variables d'environnement pour la session utilisateur
  home.sessionVariables = {
    NIXOS_OZONE_WL = "1";  # Pour les apps Electron
    WLR_NO_HARDWARE_CURSORS = "1";  # Si problème avec Nvidia
  };
}


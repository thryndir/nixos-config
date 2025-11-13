{ config, pkgs, lib, ... }:

{
  home.packages = with pkgs;
  [
    waybar pavucontrol networkmanagerapplet
  ];
  # Activer le programme waybar
  programs.waybar.enable = true;

  # Utiliser xdg.configFile pour créer le fichier de configuration de waybar
  # dans ~/.config/waybar/config
  xdg.configFile."waybar/config" =
  {
    text = ''
      {
        "layer": "top",
        "position": "top",
        "height": 30,
        "modules-left": [
          "hyprland/workspaces",
          "hyprland/window"
        ],
        "modules-center": [
          "clock"
        ],
        "modules-right": [
          "pulseaudio",
          "network",
          "backlight",
          "battery",
          "tray"
        ],
        "hyprland/workspaces": {
          "format": "{id}"
        },
        "clock": {
          "format": "{:%H:%M}",
          "tooltip-format": "{:%Y-%m-%d}"
        },
        "pulseaudio": {
          "format": "{volume}% {icon}",
          "format-icons": {
            "default": ["", ""]
          },
          "format-muted": "",
          "on-click": "pavucontrol"
        },
        "network": {
          "format-wifi": "{essid} ({signalStrength}%) ",
          "format-ethernet": "{ifname} ",
          "format-disconnected": "Disconnected ⚠",
          "tooltip-format": "{ifname}: {ipaddr}",
          "on-click": "nm-applet"
        },
        "backlight": {
          "device": "intel_backlight",
          "format": "{percent}% {icon}",
          "format-icons": ["", "💡"],
          "on-scroll-up": "brightnessctl set +5%",
          "on-scroll-down": "brightnessctl set 5%-"
        },
        "battery": {
          "states": {
            "warning": 30,
            "critical": 15
          },
          "format": "{capacity}% {icon}",
          "format-icons": ["", "", "", "", ""]
        }
      }
    '';
  };
}

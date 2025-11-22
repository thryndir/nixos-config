{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland =
  {
    enable = true;
    xwayland.enable = true;

    # C'est ici que la magie opère : on passe du "Nix" structuré
    settings =
    {
      monitor = ",preferred,auto,1";
      input.touchpad.natural_scroll = true;
      misc =
      {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      bind =
      [
        "SUPER, Return, exec, kitty"
        "SUPER, Q, killactive"
        "SUPER, M, exit"
        "SUPER, D, exec, noctalia-shell ipc call launcher toggle"
        
        # Luminosité
        ", XF86MonBrightnessUp, exec, brightnessctl set +5%"
        ", XF86MonBrightnessDown, exec, brightnessctl set 5%-"
        
        # Volume (Notez l'utilisation des variables Nix ici !)
        ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ]
      ++ ( builtins.concatLists
          (builtins.genList
            (
              x: let
                ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
              in [
                "SUPER, ${ws}, workspace, ${toString (x + 1)}"
                "SUPER SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
              ]
            )
          10)
      );
    };
  };
}

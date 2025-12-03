{ ... }:
{
  wayland.windowManager.hyprland =
  {
    enable = true;
    xwayland.enable = true;

    settings =
    {
      monitor = ",preferred,auto,1";

      general =
      {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 3;
        "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg";
        "col.inactive_border" = "rgba(595959aa)";
        layout = "dwindle";
      };

      decoration =
      {
        rounding = 8;
        blur =
        {
          enabled = true;
          size = 3;
          passes = 1;
        };
      };

      cursor =
      {
        no_warps = true;
        persistent_warps = true;
        hide_on_key_press = true;
        inactive_timeout = 3;
      };

      input =
      {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad.natural_scroll = true;
      };

      misc =
      {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      dwindle =
      {
        pseudotile = true;
        preserve_split = true;
      };

      "$mainMod" = "SUPER";

      bind =
      [
        "$mainMod, Return, exec, kitty"
        "$mainMod, Q, killactive"
        "$mainMod, F, togglefloating"
        "$mainMod, P, pseudo"
        "$mainMod, V, togglesplit"
        
        "$mainMod, SPACE, exec, noctalia-shell ipc call launcher toggle"
        "$mainMod, ESCAPE, exec, noctalia-shell ipc call lockScreen lock"

        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        "$mainMod, R, submap, resize"

        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ]
      ++ (builtins.concatLists (builtins.genList
        (
          x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in
          [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );
    };
    
    extraConfig = ''
      # Définition du mode resize
      submap = resize

      # Redimensionnement Vim (HJKL)
      # binde = répète l'action tant qu'on appuie
      binde = , l, resizeactive, 20 0
      binde = , h, resizeactive, -20 0
      binde = , k, resizeactive, 0 -20
      binde = , j, resizeactive, 0 20

      # Sortie du mode
      bind = , escape, submap, reset 
      bind = , return, submap, reset
      bind = SUPER, R, submap, reset # Sortir avec le même raccourci

      submap = reset
    '';
  };
}


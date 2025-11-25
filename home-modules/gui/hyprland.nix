{ config, pkgs, lib, ... }:
{
  wayland.windowManager.hyprland =
  {
    enable = true;
    xwayland.enable = true;

    plugins =
    [
      pkgs.hyprlandPlugins.hy3
    ];
    
    settings =
    {
      monitor = ",preferred,auto,1";

      general =
      {
        gaps_in = 3;
        gaps_out = 8;
        border_size = 3;
        "col.active_border" = "rgba(7aa2f7ee) rgba(bb9af7ee) 45deg"; # Couleurs TokyoNight
        "col.inactive_border" = "rgba(595959aa)";
        layout = "hy3";
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

      # --- INPUT (Clavier/Souris) ---
      input =
      {
        kb_layout = "us";
        follow_mouse = 1; # Le focus suit la souris (standard tiling)
        touchpad.natural_scroll = true;
      };

      # --- MISC ---
      misc =
      {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # --- GESTIONNAIRE DE FENÊTRES (Layouts) ---
      dwindle =
      {
        pseudotile = true; # Permet de garder une fenêtre flottante dans le tiling
        preserve_split = true;
      };

      # --- KEYBINDINGS (La partie fun) ---
      "$mainMod" = "SUPER"; # Variable pour ne pas répéter SUPER

      bind =
      [
        # Bases
        "$mainMod, Return, exec, kitty"
        "$mainMod, Q, killactive"
        "$mainMod, F, togglefloating" # Rendre une fenêtre flottante
        "$mainMod, P, pseudo" # Mode pseudo-tiling
        "$mainMod, V, togglesplit" # Changer l'orientation du split
        
        "$mainMod, SPACE, exec, noctalia-shell ipc call launcher toggle"
        "$mainMod, ESCAPE, exec, noctalia-shell ipc call lockScreen lock"

        # --- NAVIGATION VIM (Focus) ---
        # Se déplacer entre les fenêtres avec HJKL (Gauche, Bas, Haut, Droite)
        "$mainMod, H, movefocus, l"
        "$mainMod, L, movefocus, r"
        "$mainMod, K, movefocus, u"
        "$mainMod, J, movefocus, d"

        # --- DÉPLACEMENT DE FENÊTRES ---
        # Déplacer la fenêtre active vers une direction
        "$mainMod SHIFT, H, movewindow, l"
        "$mainMod SHIFT, L, movewindow, r"
        "$mainMod SHIFT, K, movewindow, u"
        "$mainMod SHIFT, J, movewindow, d"

        # --- MULTIMÉDIA ---
        ", XF86MonBrightnessUp, exec, noctalia-shell ipc call brightness increase"
        ", XF86MonBrightnessDown, exec, noctalia-shell ipc call brightness decrease"
        ", XF86AudioRaiseVolume, exec, noctalia-shell ipc call volume increase"
        ", XF86AudioLowerVolume, exec, noctalia-shell ipc call volume decrease"
        ", XF86AudioMute, exec, noctalia-shell ipc call volume muteOutput"
        ", XF86AudioPlay, exec, noctalia-shell ipc call media playPause"
        ", XF86AudioNext, exec, noctalia-shell ipc call media next"
        ", XF86AudioPrev, exec, noctalia-shell ipc call media previous"
      ]
      ++ (builtins.concatLists (builtins.genList (
          x: let
            ws = let c = (x + 1) / 10; in builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, workspace, ${toString (x + 1)}"
            "$mainMod SHIFT, ${ws}, movetoworkspace, ${toString (x + 1)}"
          ]
        )
        10)
      );

      # --- GESTION SOURIS (Mouse Bindings) ---
      # Le clic droit maintenu (mouse:273) redimensionne, le gauche (mouse:272) déplace
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}


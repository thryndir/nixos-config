{pkgs, inputs, ...}:
{
  imports =
  [
    inputs.hyprpanel.homeManagerModules.hyprpanel
  ];

  home.packages = with pkgs;
  [
    font-awesome nerd-fonts.jetbrains-mono libgtop bluez dart-sass fd brightnessctl
  ];

  programs.hyprpanel =
  {
    enable = true;
    systemd.enable = true;
    overlay.enable = true;
    hyprland.enable = true;
    settings =
    {
      bar.launcher.autoDetection = true;
      bar.workspaces.show_icons = true;
      theme.bar.transparent = true;
      theme.font.name = "JetBrainsMono Nerd Font";
      theme.font.size = "14px";
    };
  };
}

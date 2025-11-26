{ pkgs, config, ... }:
{
  stylix =
  {
    enable = true;
    base16Scheme = ./tokyo-night-official.yaml;
    image = config.lib.stylix.pixel "base00";
    polarity = "dark";

    fonts =
    {
      monospace =
      {
        package = pkgs.nerd-fonts.jetbrains-mono;
        name = "JetBrainsMono Nerd Font Mono";
      };
    };
    targets.helix.enable = false;
    targets.hyprland.enable = false;
  };
}


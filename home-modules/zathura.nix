{ config, ... }:
let
  colors = config.lib.stylix.colors.withHashtag;
in
{
  programs.zathura =
  {
    enable = true;
    options = {
      adjust-open = "best-fit";
      selection-clipboard = "clipboard";
      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;
      default-bg      = colors.base00;
      statusbar-bg    = colors.base01;
      completion-bg   = colors.base01;
      notification-bg = colors.base01;
      inputbar-bg     = colors.base01;
      default-fg      = colors.base05;
      statusbar-fg    = colors.base05;
      completion-fg   = colors.base05;
      notification-fg = colors.base05;
      inputbar-fg     = colors.base05;
      recolor-darkcolor  = colors.base00;
      recolor-lightcolor = colors.base05;
      highlight-color        = colors.base02;
      highlight-active-color = colors.base03;
      notification-error-bg   = colors.base00;
      notification-error-fg   = colors.base08;
      notification-warning-bg = colors.base00;
      notification-warning-fg = colors.base0A;
      notification-info-bg    = colors.base00;
      notification-info-fg    = colors.base0D;
      index-fg        = colors.base05;
      index-bg        = colors.base00;
      index-active-fg = colors.base00;
      index-active-bg = colors.base0D;
    };

    mappings =
    {
      "<C-d>" = "half-down";
      "<C-u>" = "half-up";
      "<C-f>" = "full-down";
      "<C-b>" = "full-up";

      "tn" = "tab-next";
      "tp" = "tab-prev";
    };
  };
}


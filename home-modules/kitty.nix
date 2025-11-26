{
  programs.kitty =
  {
    enable = true;
  
    settings =
    {
      font_family = "JetBrains Mono";
      bold_font = "JetBrains Mono Bold";
      italic_font = "JetBrains Mono Italic";
      bold_italic_font = "JetBrains Mono Bold Italic";
      font_size = "10.0";
      adjust_line_height = "110%";
    
      cursor_shape = "beam";
      cursor_blink_interval = "0.5";
      scrollback_lines = 10000;
      wheel_scroll_multiplier = "5.0";
    
      enabled_layouts = "splits";
      remember_window_size = "no";
      initial_window_width = "80c";
      initial_window_height = "24c";
      window_padding_width = 4;
      confirm_os_window_close = 0;
      placement_strategy = "center";
    
      tab_bar_edge = "top";
      tab_bar_style = "powerline";
      tab_powerline_style = "slanted";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "normal";
    
      enable_audio_bell = false;
      copy_on_select = "yes";
      strip_trailing_spaces = "smart";
      shell_integration = "enabled";
    };

    keybindings =
    {
      "ctrl+shift+p" = "launch --location=hsplit --cwd=current";
      "ctrl+shift+n" = "launch --location=vsplit --cwd=current";
    
      "alt+h" = "neighboring_window left";
      "alt+j" = "neighboring_window down";
      "alt+k" = "neighboring_window up";
      "alt+l" = "neighboring_window right";
    
      "ctrl+shift+h" = "resize_window narrower 3";
      "ctrl+shift+l" = "resize_window wider 3";
      "ctrl+shift+k" = "resize_window taller 3";
      "ctrl+shift+j" = "resize_window shorter 3";
    
      "ctrl+shift+t" = "new_tab";
      "ctrl+shift+right" = "next_tab";
      "ctrl+shift+left" = "previous_tab";
      "ctrl+shift+enter" = "launch --type=tab --cwd=current";
      "ctrl+shift+q" = "close_window";
    
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
    
      "alt+e" = "send_text all yazi\\x0d";
    };
  
    # themeFile = "tokyo_night_night";
  };
}

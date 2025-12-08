{ config, pkgs, ... }:
let
  musicDir = "${config.home.homeDirectory}/obsidian+music/Music";
in
{
  home.packages = [
    pkgs.yt-dlp
    pkgs.mpd-sima
    pkgs.picard
    pkgs.chromaprint
    pkgs.opusTools
  ];

  services.mpd = {
    enable = true;
    musicDirectory = "${musicDir}/albums";
    network.startWhenNeeded = true;
    
    extraConfig = ''
      audio_output {
        type "pipewire"
        name "PipeWire Output"
      }
    '';
  };

  programs.ncmpcpp = {
    enable = true;
    
    settings = {
      mpd_host = "localhost";
      mpd_port = 6600;
      mpd_music_dir = "${musicDir}/albums";
      
      user_interface = "alternative";
      playlist_display_mode = "columns";
      browser_display_mode = "columns";
      
      autocenter_mode = "yes";
      centered_cursor = "yes";
      cyclic_scrolling = "yes";
      
      colors_enabled = "yes";
      main_window_color = "white";
      progressbar_color = "cyan";
    };
  };

  programs.beets =
  {
    enable = true;

    settings =
    {
      directory = "${musicDir}/albums";
      library = "${config.home.homeDirectory}/.config/beets/musiclibrary.db";
      import =
      {
        copy = false;
        move = false;
        write = false;
        incremental = true;
        duplicate_action = "remove";
        autotag = false;
      };
      plugins =
      [
        "mpdupdate"
        "lastgenre"
        "smartplaylist"
      ];
      mpdupdate =
      {
        host = "localhost";
        port = 6600;
      };
      lastgenre =
      {
        auto = true;
        force = true;
        fallback = "";
      };
      smartplaylist =
      {
        playlist_dir = "${musicDir}/playlist";
      };
    };
  };
}


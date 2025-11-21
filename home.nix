{ config, pkgs, lib, ...}:
{
  imports =
  [
  # ++ lib.optional (config.networking.hostName == "nixos-hypr")
  # [
    ./home-modules/gui/hyprland.nix
    ./home-modules/gui/noctalia.nix
    ./home-modules/secrets.nix
  ];
  home.packages = with pkgs;
  [
    kitty nixd direnv
  ];

  programs.helix =
  {
    enable = true;
    defaultEditor = true;
  };

  programs.zsh =
  {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh =
    {
      enable = true;
      theme = "robbyrussell";
      plugins =
      [
        "git"
        "docker"
        "kubectl"
      ];
    };
    
    plugins =
    [
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub
        {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.8.0";
          sha256 = "sha256-Z6EYQdasvpl1P78poj9efnnLj7QQg13Me8x1Ryyw+dM=";
        };
      }
    ];

    # sessionVariables =
    # {
    #   EDITOR = "hx";
    #   VISUAL = "hx";
    # };
  };

  home.username = "lgalloux";
  home.homeDirectory = "/home/lgalloux";

  home.stateVersion = "24.11";
}

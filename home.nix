{ config, pkgs, lib, pkgs-unstable, ...}:
{
  imports =
  [
  # ++ lib.optional (config.networking.hostName == "nixos-hypr")
  # [
    ./home-modules/gui/hyprland.nix
    ./home-modules/gui/noctalia.nix
    ./home-modules/kitty.nix
    ./home-modules/helix.nix
  ];
  home.packages =
  [
    pkgs.nixd pkgs.direnv pkgs.discord
    pkgs-unstable.bluetui
  ];

  programs.zoxide =
  {
    enable = true;
    enableZshIntegration = true;
  };

  programs.yazi =
  {
    enable = true;
    enableZshIntegration = true;
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
  };

  home.username = "lgalloux";
  home.homeDirectory = "/home/lgalloux";

  home.stateVersion = "24.11";
}

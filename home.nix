{  pkgs, pkgs-unstable, inputs, osConfig, lib, ...}:
{
  imports =
  [
    ./home-modules/kitty.nix
    ./home-modules/helix.nix
    ./home-modules/zen.nix
    ./home-modules/stylix.nix
  ]
  ++ (lib.optionals (osConfig.networking.hostName == "nixos-hypr") 
  [
    ./home-modules/gui/hyprland.nix
    ./home-modules/gui/noctalia.nix
  ]);
    
  home.packages =
  [
    pkgs.nixd pkgs.direnv pkgs.discord
    pkgs-unstable.bluetui pkgs.delta
    pkgs.brave
  ];

  programs.git =
  {
    enable = true;
    userName = "Louis Galloux";
    userEmail = "neon.galgamergal@gmail.com";
    delta =
    {
      enable = true;
      options =
      {
        navigate = true;
        line-numbers = true;
        side-by-side = true;
      };
    };
    extraConfig =
    {
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSigh = true;
    };
  };

  programs.ssh =
  {
    enable = true;
    addKeysToAgent = "yes"; 
  };

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
        src = inputs.zsh-nix-shell;
      }
    ];
  };

  home.username = "lgalloux";
  home.homeDirectory = "/home/lgalloux";

  home.stateVersion = "24.11";
}

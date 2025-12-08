{  pkgs, config, pkgs-unstable, inputs, osConfig, lib, ...}:
{
  imports =
  [
    ./home-modules/kitty.nix
    ./home-modules/helix.nix
    ./home-modules/zen.nix
    ./home-modules/music.nix
    ./home-modules/syncthing.nix
  ]
  ++ (lib.optionals (osConfig.networking.hostName == "nixos-hypr") 
  [
    ./home-modules/gui/hyprland.nix
    ./home-modules/gui/noctalia.nix
  ])
  ++ (lib.optionals (osConfig.networking.hostName != "nixos-hypr")
  [
    ./home-modules/stylix.nix
     inputs.stylix.homeModules.stylix
  ]);
    
  home.packages =
  [
    pkgs.nixd pkgs.direnv pkgs.discord
    pkgs-unstable.bluetui pkgs.delta
    pkgs.brave pkgs.obsidian
  ];

  programs.git =
  {
    enable = true;
    settings =
    {
      user.name = "Louis Galloux";
      user.email = "neon.galgamergal@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
      commit.gpgSigh = true;
    };
  };

  stylix =
  {
    targets.zen-browser.enable = false;
    targets.helix.enable = false;
    targets.hyprland.enable = false;
  };

  programs.delta =
  {
    enable = true;
    enableGitIntegration = true;
    options =
    {
      navigate = true;
      line-numbers = true;
      side-by-side = true;
    };
  };

  programs.ssh =
  {
    enable = true;
    enableDefaultConfig = false;
    matchBlocks = {
      github =
      {
        host = "github.com";
        identityFile = "${config.home.homeDirectory}/.ssh/id_ed25519_github";
        identitiesOnly = true;
      };
    };
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

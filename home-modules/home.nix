{  pkgs, config, pkgs-unstable, inputs, osConfig, lib, ...}:
{
  imports =
  [
    ./kitty.nix
    ./helix.nix
    ./zen.nix
    ./music.nix
    ./syncthing.nix
    ./ollama.nix
  ]
  ++ (lib.optionals (osConfig.networking.hostName == "nixos-hypr") 
  [
    ./gui/hyprland.nix
    ./gui/noctalia.nix
  ])
  ++ (lib.optionals (osConfig.networking.hostName != "nixos-hypr")
  [
     inputs.stylix.homeModules.stylix
     ./stylix.nix
  ]);
    
  home.packages =
  [
    pkgs.nixd pkgs.direnv pkgs.discord
    pkgs-unstable.bluetui pkgs.delta
    pkgs.brave pkgs.obsidian pkgs.man-pages
    pkgs.man-pages-posix pkgs.linux-manual
    pkgs.aichat
  ];

  stylix =
  {
    targets.zen-browser.enable = false;
    targets.helix.enable = false;
    targets.hyprland.enable = false;
  };

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
    matchBlocks =
    {
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

    shellAliases =
    {
      zathura = "zathura --fork";
      auditor = "aichat --empty-session";
    };
    
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

  programs.zathura =
  {
    enable = true;
    options =
    {
      adjust-open = "best-fit";
      selection-clipboard = "clipboard";
      recolor = true;
      recolor-keephue = true;
      recolor-reverse-video = true;
    };
    mappings =
    {
      "<C-d>" = "scroll half-down";
      "<C-u>" = "scroll half-up";
      "<C-f>" = "scroll full-down";
      "<C-b>" = "scroll full-up";
    };
  };

  home.username = "lgalloux";
  home.homeDirectory = "/home/lgalloux";
  home.stateVersion = "24.11";
}

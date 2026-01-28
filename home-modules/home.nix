{  pkgs, config, pkgs-unstable, inputs, osConfig, lib, ...}:
{
  imports =
  [
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
    pkgs.nixd pkgs-unstable.bluetui pkgs.delta
    pkgs.brave pkgs.obsidian pkgs.man-pages 
    pkgs.man-pages-posix pkgs.aichat
    pkgs.htop pkgs.nvtopPackages.nvidia
  ];

  stylix =
  {
    targets.zen-browser.enable = false;
    targets.helix.enable = false;
    targets.hyprland.enable = false;
  };
  
  services.ssh-agent.enable = true;

  xdg.portal =
  {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals =
    [
      pkgs.xdg-desktop-portal-hyprland
      pkgs.xdg-desktop-portal-gtk
    ];
    config =
    {
      common.default = [ "gtk" ];
      hyprland.default = [ "hyprland" "gtk" ];
    };
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

  programs.alacritty =
  {
    enable = true;
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

  programs.direnv =
  {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
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
      auditor = "ollama run auditor";
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
  };

  home.username = "lgalloux";
  home.homeDirectory = "/home/lgalloux";
  home.stateVersion = "25.11";
}

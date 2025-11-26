{ pkgs, ... }: 
let
  # On récupère la palette de couleurs active de Stylix
  # (withHashtag ajoute automatiquement le '#' devant, ex: "#1a1b26")
in
{
  imports = [./zen-theme.nix];

  xdg.mimeApps =
  {
    enable = true;
    defaultApplications =
    {
      "text/html" = "zen.desktop";
      "x-scheme-handler/http" = "zen.desktop";
      "x-scheme-handler/https" = "zen.desktop";
      "x-scheme-handler/about" = "zen.desktop";
      "x-scheme-handler/unknown" = "zen.desktop";
    };
  };

  programs.zen-browser =
  {
    enable = true;
    
    # --- Policies & Extensions ---
    policies =
    let
      mkExtension = id:
      {
        install_url = "https://addons.mozilla.org/firefox/downloads/latest/${id}/latest.xpi";
        installation_mode = "force_installed";
      };
    in
     {
      DisableTelemetry = true;
      DisablePocket = true;
      DisableFirefoxStudies = true;
      DontCheckDefaultBrowser = true;
      
      ExtensionSettings =
      {
        "uBlock0@raymondhill.net" = mkExtension "ublock-origin";
        "addon@darkreader.org" = mkExtension "darkreader";
        "tridactyl.vim@cmcaine.co.uk" = mkExtension "tridactyl-vim";
        "bitwarden-password-manager@8bit.solutions" = mkExtension "bitwarden-password-manager";
        
        # Note : On n'a plus besoin de l'extension de thème ici,
        # car on va thémer Zen directement via CSS + Stylix ci-dessous !
      };
    };

    # --- Profil Utilisateur ---
    profiles.lgalloux =
    {
      isDefault = true;
      
      # Paramètres pour activer le CSS Custom
      settings =
      {
        "zen.view.compact.hide-tabbar" = true;
        "zen.view.compact.hide-toolbar" = false;
        "zen.workspaces.natural-scroll" = true;
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true; # CRUCIAL
        "svg.context-properties.content.enabled" = true;            # CRUCIAL pour les icônes
        "gfx.webrender.all" = true;
        "ui.systemUsesDarkTheme" = 1;
      };


      # Moteurs de recherche (avec alias)
      search =
      {
        force = true;
        default = "ddg"; # Attention "DuckDuckGo" -> "ddg"
        engines =
        {
          "Nix Packages" =
          {
            urls = [{ template = "https://search.nixos.org/packages?channel=unstable&query={searchTerms}"; }];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = [ "@np" ];
          };
        };
      };

      spaces =
      {
        "Dev" =
        {
          id = "12345678-1234-1234-1234-123456789001";
          icon = "💻";
          position = 1;
        };
        "Perso" =
        {
          id = "12345678-1234-1234-1234-123456789002";
          icon = "🏠";
          position = 2;
        };
      };
    };
  };
}


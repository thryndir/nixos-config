{  config, ...}:
let
    c = config.lib.stylix.colors.withHashtag;
    darkReaderConfig =
    {
      schemeVersion = 2;
      enabled = true;
      fetchNews = true;
      theme =
      {
        mode = 1;
        brightness = 100;
        contrast = 100;
        grayscale = 0;
        sepia = 0;
        useFont = false;
        fontFamily = "Open Sans";
        textStroke = 0;
        engine = "dynamicTheme";
        stylesheet = "";
      
        # --- Couleurs Dynamiques Stylix ---
        darkSchemeBackgroundColor = c.base00;
        darkSchemeTextColor = c.base06;
        lightSchemeBackgroundColor = c.base07;
        lightSchemeTextColor = c.base00;
      
        scrollbarColor = "auto";
        selectionColor = "auto";
        styleSystemControls = true;
        lightColorScheme = "Default";
        darkColorScheme = "Default";
        immediateModify = false;
      };
      presets = [];
      customThemes = [];
      siteList = [];
      siteListEnabled = [];
      applyToListedOnly = false;
      changeBrowserTheme = false;
      syncSettings = true;
      syncSitesFixes = true;
      automation =
      {
        enabled = false;
        mode = "";
        behavior = "OnOff";
        startTime = "18:00";
        endTime = "09:00";
      };
      time =
      {
        activation = "18:00";
        deactivation = "09:00";
      };
      location =
      {
        latitude = null;
        longitude = null;
      };
      previewNewDesign = false;
      enableForPDF = true;
      enableForProtectedPages = false;
      enableContextMenus = false;
    };
in
{
  programs.zen-browser.profiles.lgalloux.userChrome =
  ''
    /* ==========================================================================
       ZEN BROWSER x STYLIX (TOKYO NIGHT)
       ========================================================================== */

    :root {
      /* --- 1. VARIABLES GLOBALES (Mapping Stylix) --- */
      --zen-colors-primary: ${c.base0D} !important;   /* Accent (Bleu) */
      --zen-colors-secondary: ${c.base0E} !important; /* Secondaire (Violet) */
      --zen-colors-tertiary: ${c.base0C} !important;  /* Tertiaire (Cyan) */
      --zen-colors-border: ${c.base01} !important;    /* Bordures */
  
      --toolbar-bgcolor: ${c.base00} !important;      /* Fond Principal */
      --lwt-text-color: ${c.base05} !important;       /* Texte Principal */
  
      /* Variables spécifiques Zen */
      --zen-dialog-background: ${c.base00} !important;
    }

    /* ==========================================================================
       2. INTERFACE GÉNÉRALE
       ========================================================================== */

    /* Force le fond sur toute la fenêtre principale */
    #main-window, #navigator-toolbox, #browser, #appcontent {
      background-color: ${c.base00} !important;
    }

    /* Barre d'URL (Omnibox) */
    #urlbar-background {
      background-color: ${c.base01} !important;
      border: 1px solid ${c.base02} !important;
    }
    #urlbar-input {
      color: ${c.base05} !important;
    }

    /* Onglet actif */
    .tab-background[selected="true"] {
      background-color: ${c.base02} !important;
      border-top: 2px solid ${c.base0D} !important;
    }

    /* ==========================================================================
       3. SIDEBAR (MODE NORMAL)
       ========================================================================== */

    #zen-sidebar, 
    #zen-sidebar-web-panel,
    .zen-sidebar-box {
      background-color: ${c.base00} !important;
      border-right: 1px solid ${c.base01} !important;
    }

    /* Boutons Sidebar */
    #zen-sidebar toolbarbutton {
      fill: ${c.base04} !important;
    }
    #zen-sidebar toolbarbutton:hover {
      background-color: ${c.base02} !important;
      fill: ${c.base0D} !important;
      border-radius: 6px !important;
    }

    /* ==========================================================================
       4. SIDEBAR (MODE COMPACT / FLOTTANT) - LE PATCH
       ========================================================================== */

    /* Cible la classe coupable trouvée dans le code source */
    .zen-toolbar-background {
        background: ${c.base00} !important; /* Écrase le #131313 */
        backdrop-filter: none !important;   /* Désactive le flou acrylique */
        box-shadow: none !important;
    }

    /* Nettoyage des effets de bordures/lumières de Zen */
    .zen-toolbar-background::before,
    .zen-toolbar-background::after {
        background: transparent !important;
        outline: none !important;
    }

    /* Wrapper de la sidebar flottante */
    #zen-sidebar-wrapper,
    .zen-sidebar-compact-wrapper {
         background-color: ${c.base00} !important;
    }

    /* Force les éléments internes du panneau compact */
    #zen-sidebar-web-panel {
         background-color: ${c.base00} !important;
    }
  '';
  home.file.".config/darkreader-stylix.json".text = builtins.toJSON darkReaderConfig;
}

{ config, ... }:
{
  services.syncthing =
  {
    enable = true;
  };

  services.syncthing.settings =
  {
    folders = {
      "music+obsidian-id" =
      {  # ID unique (doit être le même sur ton tel)
        path = "${config.home.homeDirectory}/obsidian+music";
        label = "notes and music";
        type = "sendreceive"; # Bidirectionnel
        versioning =
        {
          type = "staggered"; # Le fameux backup de sécurité
          params =
          {
            cleanInterval = "3600";
            maxAge = "15552000"; # Garde les versions 180 jours
          };
        };
      };
    };
  }; 
}

{ config, ... }:
{
  services.syncthing =
  {
    enable = true;
  };

  services.syncthing.settings =
  {
    devices =
    {
      "myPhone" =
      {
        id = "W3XMLW3-Y3G3S54-GC2FNGU-VDL6U64-UTWOKFH-HMQZVPK-PFKE5TD-UJXPVAT";
        autoAcceptFolders = true;
      };
    };
    folders =
    {
      "music-id" =
      {  # ID unique (doit être le même sur ton tel)
        path = "${config.home.homeDirectory}/Music";
        label = "Music";
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
      "notes-id" =
      {
        path = "${config.home.homeDirectory}/2nd_Brain";
        label = "Notes";
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

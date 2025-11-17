{ pkgs, config, lib, ... }:

{
  # --- Paquets nécessaires ---
  home.packages = with pkgs; [
    gnupg pass pass-secret-service gcr
  ];

  # --- Configuration de GPG Agent ---
  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
    extraConfig = ''
      allow-loopback-pinentry
      allow-preset-passphrase
    '';
  };

  home.file.".pam-gnupg".text =
  ''
    5127EE13833060CF4D57B12BC27A911BF7D81D4B
  '';
    
  services.ssh-agent.enable = true;

  home.file.".local/share/dbus-1/services/org.freedesktop.secrets.service".text =
    ''
      [D-BUS Service]
      Name=org.freedesktop.secrets
      Exec=${pkgs.pass-secret-service}/bin/pass_secret_service
      SystemdService=dbus-org.freedesktop.secrets.service
    '';

  # --- Service systemd ---
  # IMPORTANT : Le nom doit être "dbus-org.freedesktop.secrets" pour correspondre
  # au fichier D-Bus ci-dessus
  systemd.user.services."dbus-org.freedesktop.secrets" = {
    Unit = {
      Description = "Expose the libsecret dbus api with pass as backend";
    };

    Service = {
      Type = "dbus";
      BusName = "org.freedesktop.secrets";
      ExecStart = "${pkgs.pass-secret-service}/bin/pass_secret_service";
      
      # Variables d'environnement pour l'interface graphique
      Environment = [
        "DISPLAY=:0"
        "DBUS_SESSION_BUS_ADDRESS=unix:path=/run/user/1000/bus"
      ];
    };

    Install = {
      WantedBy = [ "default.target" ];
    };
  };
}


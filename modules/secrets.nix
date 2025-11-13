{ pkgs, config, ...}:

{
  home.packages = with pkgs;
  [
    gnupg pass pass-secret-service
    pinentry-gnome3
  ];

  services.gpg-agent =
  {
    enable = true;
    pinentry.package = pkgs.pinentry-gnome3;
  };
}


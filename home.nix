{ config, pkgs, lib, ...}:
{
  imports =
  [
  # ++ lib.optional (config.networking.hostName == "nixos-hypr")
  # [
    ./modules/gui/hyprland.nix
    ./modules/gui/waybar.nix
    ./modules/secrets.nix
  ];
  home.packages = with pkgs;
  [
    firefox alacritty helix
  ];

  home.username = "lgalloux";
  home.homeDirectory = "/home/lgalloux";

  home.stateVersion = "24.11";
}

{
  inputs =
  {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    home-manager =
    {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    noctalia =
    {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    tokyonight-sddm-src =
    {
      url = "github:rototrash/tokyo-night-sddm";
      flake = false;
    };
  };
  outputs = { nixpkgs, nixpkgs-unstable, home-manager, tokyonight-sddm-src, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = import nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
      overlays =
      [
        (final: prev:
        {
          sddm-tokyonight = prev.stdenv.mkDerivation
          {
            pname = "sddm-tokyonight";
            version = "1.0";
            src = tokyonight-sddm-src;
            dontBuild = true;
            themeConfig = import ./sddm-theme.nix { pkgs = prev; };
            installPhase =
            ''
              mkdir -p $out/share/sddm/themes/tokyonight-sddm
              cp -r $src/* $out/share/sddm/themes/tokyonight-sddm
              cp $themeConfig $out/share/sddm/themes/tokyonight-sddm/theme.conf
            '';
          };
        })
      ];
    };
    pkgs-unstable = import nixpkgs-unstable
    {
      inherit system;
      config.allowUnfree = true;
    };
  in
  {
    nixosConfigurations.nixos-hypr = nixpkgs.lib.nixosSystem
    {
      inherit pkgs;

      specialArgs =
      {
        inherit inputs pkgs-unstable;
      };
      modules =
      [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.users.lgalloux = import ./home.nix;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs =
          {
            inherit inputs pkgs-unstable;
          };
        }
        ./configuration.nix
      ];
    };
    homeConfigurations.lgalloux = home-manager.lib.homeManagerConfiguration
    {
      inherit pkgs;
      modules = [ ./home.nix ];
    };
  };
}

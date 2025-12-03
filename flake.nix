{
  inputs =
  {
    nixpkgs.url = "github:NixOs/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOs/nixpkgs/nixos-unstable";
    nur.url = "github:nix-community/NUR";
    zsh-nix-shell =
    {
      url = "github:chisui/zsh-nix-shell/master";
      flake = false;
    };
    zen-browser =
    {
      url = "github:0xc000022070/zen-browser-flake";
      inputs =
      {
        nixpkgs.follows = "nixpkgs";
        home-manager.follows = "home-manager";
      };
    };
    home-manager =
    {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix =
    {
      url = "github:nix-community/stylix/release-25.05";
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
    myOverlay = final: prev:
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
          chmod -R u+w $out/share/sddm/themes/tokyonight-sddm
          cp $themeConfig $out/share/sddm/themes/tokyonight-sddm/theme.conf
        '';
      };
    };
    pkgs = import nixpkgs
    {
      inherit system;
      config.allowUnfree = true;
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
      inherit system;

      specialArgs =
      {
        inherit inputs pkgs-unstable;
      };
      modules =
      [
        {
          nixpkgs.overlays =
          [
            inputs.nur.overlays.default
            myOverlay
          ];
          nixpkgs.config.allowUnfree = true;
        }
        {
          home-manager.useGlobalPkgs = true;
          home-manager.users.lgalloux = import ./home.nix; 
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs =
          {
            inherit inputs pkgs-unstable;
          };
        }
        home-manager.nixosModules.home-manager
        ./configuration.nix
      ];
    };
    homeConfigurations.lgalloux = home-manager.lib.homeManagerConfiguration
    {
      modules =
      [
        ./home.nix
      ];
      extraSpecialArgs =
      {
        inherit pkgs inputs
        pkgs-unstable;
      };
    };
  };
}

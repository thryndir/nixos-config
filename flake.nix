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
    quickshell =
    {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    noctalia =
    {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.quickshell.follows = "quickshell";
    };
  };
  outputs = { nixpkgs, nixpkgs-unstable, home-manager, ... }@inputs:
  let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
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

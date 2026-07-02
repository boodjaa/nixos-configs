# /etc/nixos/flake.nix
{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    preservation = {
      url = "github:nix-community/preservation";
    };

    sysc-greet = {
    	url = "github:Nomadcxx/sysc-greet";
	inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, preservation, sysc-greet, ... } @ inputs: {
    nixosConfigurations."nixos" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

	# Preservation module
	preservation.nixosModules.preservation

	# Home-Manager as-module, single-user mode
	home-manager.nixosModules.home-manager
	{
	  home-manager = {
	    useGlobalPkgs	= true;
	    useUserPackages	= true;
	    backupFileExtension	= "bak";
	    extraSpecialArgs	= { inherit inputs; };

	    users.jamig = import ./home.nix;
	  };
	}

	# Sysc-greet
	sysc-greet.nixosModules.default
      ];
    };
  };
}

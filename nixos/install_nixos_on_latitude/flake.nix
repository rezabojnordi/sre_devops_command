{
  inputs = {
    # We use the stable 24.11 version of NixOS
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    
    # Import the Disko tool for partitioning
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, disko, ... }: {
    nixosConfigurations.server2 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        disko.nixosModules.disko
        ./disko-config.nix
        ./configuration.nix
      ];
    };
  };
}

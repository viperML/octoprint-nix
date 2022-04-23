{
  description = "NixOS configuration for a raspberry pi with octoprint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.11";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    deploy-rs,
  }: {
    nixosConfigurations.raspi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        ./modules/common.nix
        ./modules/admin.nix
        ./modules/octoprint.nix
      ];
    };

    deploy.nodes.raspi = {
      # Set up the hostname here or in .ssh/config
      hostname = "raspi";
      fastConnection = false;
      profiles.system = {
        sshUser = "admin";
        path =
          deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.raspi;
        user = "root";
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}

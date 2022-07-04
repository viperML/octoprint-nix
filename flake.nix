{
  description = "NixOS configuration for a raspberry pi with octoprint";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.05";
    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    deploy-rs,
  }: let
    inherit (nixpkgs) lib;
    genSystems = lib.genAttrs lib.systems.flakeExposed;
  in {
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

    packages."aarch64-linux".default = self.nixosConfigurations.raspi.config.system.build.sdImage;

    apps = genSystems (system: {
      default = {
        type = "app";
        program = deploy-rs.packages.${system}.deploy-rs.outPath + "/bin/deploy";
      };
    });

    deploy.nodes.raspi = {
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

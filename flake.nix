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

    # Default targets for "nix build"
    packages =
      lib.genAttrs [
        "x86_64-linux" # Compile image in QEMU-user with binfmt
        "aarch64-linux" # Compile in a native (or virtualized) system
      ] (system: {
        default = self.nixosConfigurations.raspi.config.system.build.sdImage;
      });

    # Default targets for "nix run"
    apps =
      lib.genAttrs [
        "x86_64-linux"
        "aarch64-linux"
      ] (system: {
        default = {
          type = "app";
          program = lib.getExe deploy-rs.packages.${system}.deploy-rs;
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

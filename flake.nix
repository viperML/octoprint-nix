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
    ...
  }: {
    nixosConfigurations.raspi = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        (import ./modules/admin.nix)
        (import ./modules/common.nix)
        (import ./modules/hardware.nix)
        (import ./modules/octoprint.nix)
      ];
    };

    deploy.nodes.raspi = {
      hostname = "raspi";
      fastConnection = false;
      profiles.system = {
        sshUser = "admin";
        path =
          inputs.deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.raspi;
        user = "root";
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) inputs.deploy-rs.lib;
  };
}

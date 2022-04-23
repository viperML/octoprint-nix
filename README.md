# octoprint-raspi

Simple NixOS configuration for a Raspberry Pi running octoprint.

## Create a flashable image

```console
nix build .#nixosConfigurations.raspi.config.system.build.sdImage -L
```

This may require cross-compilation support:

```nix
# configuration.nix
{ config, pkgs, ... }: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
```

## Update a running system

```console
nix run github:serokell/deploy-rs .#raspi
```

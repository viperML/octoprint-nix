# octoprint-raspi

Simple NixOS configuration for a Raspberry Pi running octoprint.

## Create a flashable image

```nix
nix build .#nixosConfigurations.raspi.config.system.build.sdImage -L
```

This may require cross-compilation support
The image will be compressed and linked under ./result

## Update a running system

```
nix run github:serokell/deploy-rs .#raspi
```

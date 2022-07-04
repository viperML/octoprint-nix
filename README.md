# octoprint-raspi

Simple NixOS configuration for a Raspberry Pi running octoprint.

## Create a flashable image

```console
nix build .#packages.aarch64-linux.default
```

To build the SD card image, you need an aarch64-linux system. Otherwise, if you are on NixOS, you can use `binfmt` to build it with QEMU. Enable this option and reboot:

```nix
# configuration.nix
{ config, pkgs, ... }: {
  boot.binfmt.emulatedSystems = ["aarch64-linux"];
}
```


## Update a running system

Change the hostname or IP address in the flake, in `deploy.nodes.raspi`

```console
nix run
```

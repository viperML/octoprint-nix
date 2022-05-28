# octoprint-raspi

Simple NixOS configuration for a Raspberry Pi running octoprint.

## Create a flashable image

```console
nix build
```

The image is `aarch64-linux`, which means that you need an `aarch64-linux` to natively build it (or a VM ?).

Otherwise in NixOS `x86_64-linux`, you can use `binfmt` to use QEMU-user to automatically compile the image.
Reboot after adding this piece of config:

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

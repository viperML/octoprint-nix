{...}: {
  users.mutableUsers = false;
  users.users.admin = {
    name = "admin";
    isNormalUser = true;
    extraGroups = ["wheel"];
    # Dear visitor: change this
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM4nGcFM27G8+R8QReBuDRfQuNmAOC+0DNQ0efNyZP4d ayats@gen6"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  nix.trustedUsers = ["@wheel"]; # https://github.com/serokell/deploy-rs/issues/25
  services.openssh = {
    enable = true;
  };
  services.getty.autologinUser = "admin";
}

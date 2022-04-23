{
  config,
  pkgs,
  ...
}: {
  users.mutableUsers = false;
  users.users.admin = {
    name = "admin";
    isNormalUser = true;
    extraGroups = ["wheel"];
    # Dear visitor: change this
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIBZkBer8ozZ/6u7AQ1FHXiF1MbetEUKZoV5xN5YkhMo ayatsfer@gmail.com"
    ];
  };
  security.sudo.wheelNeedsPassword = false;
  nix.trustedUsers = ["@wheel"]; # https://github.com/serokell/deploy-rs/issues/25
  services.openssh = {enable = true;};
}

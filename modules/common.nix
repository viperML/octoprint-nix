{
  config,
  pkgs,
  inputs,
  ...
}: {
  time.timeZone = "UTC";
  system.stateVersion = "21.11";
  system.configurationRevision = inputs.self.rev or null;

  environment.systemPackages = with pkgs; [
    fish
    htop
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  networking.networkmanager.enable = true;
  networking.firewall.enable = false;
  users.groups.networkmanager.members = config.users.groups.wheel.members;
}

{
  config,
  pkgs,
  inputs,
  ...
}: {
  time.timeZone = "UTC";
  system.stateVersion = "22.05";
  system.configurationRevision = inputs.self.rev or null;

  environment.systemPackages = with pkgs; [
    fish
    htop
    neofetch
  ];

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      auto-optimise-store = true
      experimental-features = nix-command flakes
    '';
  };

  networking.networkmanager.enable = true;
  users.groups.networkmanager.members = config.users.groups.wheel.members;

  # https://github.com/jacksonliam/mjpg-streamer/issues/182#issuecomment-860181361
  boot.loader.raspberryPi.firmwareConfig = ''
    gpu_mem=256
  '';
}

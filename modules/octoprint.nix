{
  config,
  pkgs,
  ...
}:
{
  services = {
    octoprint = {
      enable = true;
      plugins = (
        plugins:
          with plugins; [
            telegram
          ]
      );
    };
    # TODO fix
    mjpg-streamer.enable = true;
  };
}

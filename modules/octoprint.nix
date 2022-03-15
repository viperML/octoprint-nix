{
  config,
  pkgs,
  ...
}: {
  services = {
    octoprint = {
      enable = true;
      port = 5000;
      plugins = (
        plugins:
          with plugins; [
            telegram
          ]
      );
    };

    # Octoprint won't bind to port 80
    # Proxy pass with nginx
    nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedOptimisation = true;
      recommendedGzipSettings = true;
      # recommendedTlsSettings = true;
      virtualHosts."raspi.local" = {
        locations."/".proxyPass = "http://localhost:5000/";
      };
    };
    # TODO video output
    # mjpg-streamer.enable = true;
  };
}

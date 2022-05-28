{...}: {
  services = {
    octoprint = {
      enable = true;
      port = 80;
      plugins = p: [
        p.telegram
      ];
    };

    # TODO video output
    # mjpg-streamer.enable = true;
  };

  systemd.services.octoprint = {
    serviceConfig = {
      AmbientCapabilities = "CAP_NET_BIND_SERVICE";
      CapabilityBoundingSet = "CAP_NET_BIND_SERVICE";
    };
  };

  networking.firewall = rec {
    allowedTCPPorts = [80];
    allowedUDPPorts = allowedTCPPorts;
  };
}

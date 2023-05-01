{ ... }: {
  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
    containers = {
      registries.search = [ "docker.io" ];
    };
  };
}

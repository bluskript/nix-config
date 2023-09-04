{...}: {
  services.distrobox = {
		enable = true;
    arch = {
      image = "arch:latest";
      home = "/persist/home/blusk/distros/arch";
    };
  };
}

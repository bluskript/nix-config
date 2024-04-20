{...}: {
  users.users.blusk.extraGroups = ["syncthing"];
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    overrideDevices = true;
    overrideFolders = true;
    dataDir = "/persist/home/blusk/Documents";
    settings = {
      devices = {
        "phone" = {id = "ZSLUX2F-4DYBYTL-DNFUBWU-E62GMMO-F2FLP76-XMY2H7M-N2E4G3D-IYMO6QG";};
      };
      folders."main_vault" = {
        path = "/persist/home/blusk/vault/main";
        devices = ["phone"];
        ignorePerms = true;
      };
    };
  };
}

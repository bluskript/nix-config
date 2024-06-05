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
        "felys" = {id = "Y3TQBUJ-M5ZX3GO-NA4QGQV-7UBIHCN-XBYQULE-SXAQGBH-EWM2JHV-SIOSWQK";};
        "phone" = {id = "ZSLUX2F-4DYBYTL-DNFUBWU-E62GMMO-F2FLP76-XMY2H7M-N2E4G3D-IYMO6QG";};
      };
      folders."main_vault" = {
        path = "/persist/home/blusk/vault/main";
        devices = ["phone" "felys"];
        ignorePerms = true;
      };
    };
  };
}

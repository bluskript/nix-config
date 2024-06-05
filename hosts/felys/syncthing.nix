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
        "NoAH-II" = {id = "IRAOIJL-ZNG2RJC-Z5X32HO-CV23NBE-D6VQKRX-GS6IOSV-EXV67MG-RY3NAA7";};
        "phone" = {id = "ZSLUX2F-4DYBYTL-DNFUBWU-E62GMMO-F2FLP76-XMY2H7M-N2E4G3D-IYMO6QG";};
      };
      folders."main_vault" = {
        path = "/persist/home/blusk/vault/main";
        devices = ["phone" "NoAH-II"];
        ignorePerms = true;
      };
    };
  };
}

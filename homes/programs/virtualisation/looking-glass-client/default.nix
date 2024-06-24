{...}: {
  programs.looking-glass-client = {
    enable = true;
    settings = {
      app = {
        allowDMA = true;
        shmFile = "/dev/shm/kvmfr0";
      };
      spice = {
        enable = false;
        audio = false;
      };
      win = {
        size = "3840x2160";
        autoResize = "yes";
        quickSplash = "yes";
        jitRender = false;
      };
      input = {
        escapeKey = 56;
        rawMouse = true;
        mouseSens = 6;
      };
    };
  };
}

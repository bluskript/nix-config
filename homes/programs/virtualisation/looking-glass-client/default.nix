{ ... }: {
  programs.looking-glass-client = {
    enable = true;
    settings = {
      win = {
        size = "3840x2160";
        autoResize = "yes";
        quickSplash = "yes";
        jitRender = true;
      };
      input = {
        escapeKey = 56;
        rawMouse = "yes";
        mouseSens = 6;
      };
    };
  };
}


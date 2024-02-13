{...}: {
  # PDF reader
  programs.zathura = {
    enable = true;
    options = {
			recolor = true;
      standbox = "strict";
      selection-clipboard = "clipboard";
    };
  };
}

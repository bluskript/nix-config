{
  inputs,
  pkgs,
  ...
}: {
  xdg.configFile."discordrp-mpris/config.toml" = {
    text = ''
      [global]
      # Enable debug level logging or configure level directly
      debug = false
      log_level = "WARNING"

      poll_interval = 10
      reconnect_wait = 1

      # The following can be overridden per player.
      [options]
      # Whether to show status for paused players.
      show_paused = false
      # Whether to show status for previously active and now stopped player.
      show_stopped = false
      # Available values are: "elapsed", "remaining" or "none".
      show_time = "elapsed"
      # Upload images to the host
      # Note: if this set to true, valid image_host must be set.
      # meant to be set to true with all online players
      upload_images = true
      # Use image host to show local album covers
      # There is two conditions to use host:
      # 1) image is sent via HTTP POST
      # 2) The response will be a text which only contains URL of the uploaded image.
      image_host = "https://0x0.st"
      # Whether to ignore a player. Supposed to be overridden.
      ignore = false
      # Maximum number of bytes in the title field
      max_title_len = 64
      # informational string, usually is just artist and title
      # you can use theese formatters here: artist, albumArtist, title, album, position, length, player, state
      details = "{title}\nby {artist}"

      # You can override any of the [options] options
      # for each player individually.
      # The player name to use as the key
      # is shown in your Discord Rich Presence (hover the icons).
      [player.Spotify]
      ignore = true
    '';
  };

  systemd.user.services.discordrp-mpris = {
    Install = {
      WantedBy = ["default.target"];
    };
    Unit = {
      Description = "discordrp-mpris";
    };
    Service = {
      ExecStart = "${inputs.discordrp-mpris.packages.${pkgs.system}.default}/bin/discordrp-mpris";
      Restart = "on-failure";
      RestartSec = 5;
    };
  };
}

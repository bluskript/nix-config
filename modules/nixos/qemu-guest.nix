{
  config,
  lib,
  ...
}: let
  guestModule = {
    name,
    config,
    ...
  }:
    with lib; {
      options = {
        extraConfig = mkOption {
          type = types.string;
        };
      };
    };
in {
  options = with lib; {
    virtualization.qemu-guests = mkOption {
      type = types.attrsOf (types.submodule guestModule);
    };
  };
}

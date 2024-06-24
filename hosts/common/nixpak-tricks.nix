{ pkgs, ... }:
let
  documentPortalFileAccessTrick = pkgs.writeShellScriptBin "flatpak" ''
    [[ "$1" == "info" ]] || exit 1
    case "$3" in
      org.mozilla.Firefox)
        case "''${2#--file-access=}" in
          $HOME/Downloads*) echo read-write;;
          *) echo hidden;;
        esac;;
      *)
        echo hidden;;
    esac
  '';
in
{
  environment.systemPackages = [
    documentPortalFileAccessTrick
  ];
}


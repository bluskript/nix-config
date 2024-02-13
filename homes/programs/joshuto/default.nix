{pkgs, ...}: {
  home.packages = with pkgs; [
    file
  ];

  xdg.configFile."joshuto/theme.toml".source = ./theme.toml;

  programs.joshuto = {
    enable = true;
    settings = {
      xdg_open = true;
      xdg_open_fork = true;
      use_trash = false;
      preview.preview_script = pkgs.writeShellScript "preview_file" (builtins.readFile ./preview_file.sh);
      custom_commands = let
        rg = "${pkgs.ripgrep}/bin/rg";
        bat = "${pkgs.bat}/bin/bat";
        skim = "${pkgs.skim}/bin/sk";
        rgfzf = pkgs.writeShellScript "rgfzf" ''
          ${rg} -n -H --color=never "$@" \
            | ${skim} --ansi --preview '${bat} -n $(echo {} | cut -d ":" -f1) --line-range="$(echo {} | cut -d ":" -f2):"' \
            | cut -d ":" -f1
        '';
      in [
        {
          name = "rgfzf";
          command = "${rgfzf} '%text' %s";
        }
      ];
    };
    mimetype = {
      class.text_default = [
        {
          command = "nvim";
        }
      ];
      extension = {
        ts."inherit" = "text_default";
      };
      mimetype.text."inherit" = "text_default";
    };
    keymap = {
      default_view = {
        keymap = [
          {
            keys = ["escape"];
            commands = ["escape"];
          }
          {
            keys = ["ctrl+t"];
            commands = ["new_tab"];
          }
          {
            keys = ["alt+t"];
            commands = ["new_tab --cursor"];
          }
          {
            keys = ["T"];
            commands = ["new_tab --current"];
          }
          {
            keys = ["e"];
            commands = ["shell nvim %s"];
          }
          {
            keys = ["W"];
            commands = ["close_tab"];
          }
          {
            keys = ["ctrl+w"];
            commands = ["close_tab"];
          }
          {
            keys = ["q"];
            commands = ["close_tab"];
          }
          {
            keys = ["ctrl+c"];
            commands = ["quit"];
          }
          {
            keys = ["Q"];
            commands = ["quit --output-current-directory"];
          }

          {
            keys = ["ctrl+r"];
            commands = ["reload_dirlist"];
          }
          {
            keys = ["z" "h"];
            commands = ["toggle_hidden"];
          }
          {
            keys = ["ctrl+h"];
            commands = ["toggle_hidden"];
          }
          {
            keys = ["\t"];
            commands = ["tab_switch 1"];
          }
          {
            keys = ["backtab"];
            commands = ["tab_switch -1"];
          }

          {
            keys = ["alt+1"];
            commands = ["tab_switch_index 1"];
          }
          {
            keys = ["alt+2"];
            commands = ["tab_switch_index 2"];
          }
          {
            keys = ["alt+3"];
            commands = ["tab_switch_index 3"];
          }
          {
            keys = ["alt+4"];
            commands = ["tab_switch_index 4"];
          }
          {
            keys = ["alt+5"];
            commands = ["tab_switch_index 5"];
          }

          {
            keys = ["1"];
            commands = ["numbered_command 1"];
          }
          {
            keys = ["2"];
            commands = ["numbered_command 2"];
          }
          {
            keys = ["3"];
            commands = ["numbered_command 3"];
          }
          {
            keys = ["4"];
            commands = ["numbered_command 4"];
          }
          {
            keys = ["5"];
            commands = ["numbered_command 5"];
          }
          {
            keys = ["6"];
            commands = ["numbered_command 6"];
          }
          {
            keys = ["7"];
            commands = ["numbered_command 7"];
          }
          {
            keys = ["8"];
            commands = ["numbered_command 8"];
          }
          {
            keys = ["9"];
            commands = ["numbered_command 9"];
          }

          {
            keys = ["arrow_up"];
            commands = ["cursor_move_up"];
          }
          {
            keys = ["arrow_down"];
            commands = ["cursor_move_down"];
          }
          {
            keys = ["arrow_left"];
            commands = ["cd .."];
          }
          {
            keys = ["arrow_right"];
            commands = ["open"];
          }
          {
            keys = ["\n"];
            commands = ["open"];
          }
          {
            keys = ["home"];
            commands = ["cursor_move_home"];
          }
          {
            keys = ["end"];
            commands = ["cursor_move_end"];
          }
          {
            keys = ["page_up"];
            commands = ["cursor_move_page_up"];
          }
          {
            keys = ["page_down"];
            commands = ["cursor_move_page_down"];
          }
          {
            keys = ["ctrl+u"];
            commands = ["cursor_move_page_up 0.5"];
          }
          {
            keys = ["ctrl+d"];
            commands = ["cursor_move_page_down 0.5"];
          }
          {
            keys = ["ctrl+f"];
            commands = ["custom_search rgfzf"];
          }

          {
            keys = ["j"];
            commands = ["cursor_move_down"];
          }
          {
            keys = ["k"];
            commands = ["cursor_move_up"];
          }
          {
            keys = ["h"];
            commands = ["cd .."];
          }
          {
            keys = ["l"];
            commands = ["open"];
          }
          {
            keys = ["g" "g"];
            commands = ["cursor_move_home"];
          }
          {
            keys = ["G"];
            commands = ["cursor_move_end"];
          }
          {
            keys = ["o" "o"];
            commands = ["open_with"];
          }
          {
            keys = ["r"];
            commands = ["rename_append"];
          }
          {
            keys = ["R"];
            commands = ["rename_prepend"];
          }
          {
            keys = ["H"];
            commands = ["cursor_move_page_home"];
          }
          {
            keys = ["L"];
            commands = ["cursor_move_page_middle"];
          }
          {
            keys = ["M"];
            commands = ["cursor_move_page_end"];
          }

          {
            keys = ["["];
            commands = ["parent_cursor_move_up"];
          }
          {
            keys = ["]"];
            commands = ["parent_cursor_move_down"];
          }

          {
            keys = ["c" "d"];
            commands = [":cd "];
          }
          {
            keys = ["d" "d"];
            commands = ["cut_files"];
          }
          {
            keys = ["y" "y"];
            commands = ["copy_files"];
          }
          {
            keys = ["y" "n"];
            commands = ["copy_filename"];
          }
          {
            keys = ["y" "."];
            commands = ["copy_filename_without_extension"];
          }
          {
            keys = ["y" "p"];
            commands = ["copy_filepath"];
          }
          {
            keys = ["y" "a"];
            commands = ["copy_filepath --all-selected=true"];
          }
          {
            keys = ["y" "d"];
            commands = ["copy_dirpath"];
          }

          {
            keys = ["p" "l"];
            commands = ["symlink_files --relative=false"];
          }
          {
            keys = ["p" "L"];
            commands = ["symlink_files --relative=true"];
          }

          {
            keys = ["delete"];
            commands = ["delete_files"];
          }
          {
            keys = ["d" "D"];
            commands = ["delete_files"];
          }
          {
            keys = ["p" "p"];
            commands = ["paste_files"];
          }
          {
            keys = ["p" "o"];
            commands = ["paste_files --overwrite=true"];
          }
          {
            keys = ["a"];
            commands = [":touch "];
          }
          {
            keys = ["A"];
            commands = [":mkdir "];
          }
          {
            keys = [" "];
            commands = ["select --toggle=true"];
          }
          {
            keys = ["t"];
            commands = ["select --all=true --toggle=true"];
          }
          {
            keys = ["V"];
            commands = ["toggle_visual"];
          }

          {
            keys = ["w"];
            commands = ["show_tasks --exit-key=w"];
          }
          {
            keys = ["b" "b"];
            commands = ["bulk_rename"];
          }
          {
            keys = ["="];
            commands = ["set_mode"];
          }
          {
            keys = [":"];
            commands = [":"];
          }
          {
            keys = [";"];
            commands = [":"];
          }
          {
            keys = ["'"];
            commands = [":shell "];
          }
          {
            keys = ["m" "k"];
            commands = [":mkdir "];
          }
          {
            keys = ["/"];
            commands = [":search "];
          }
          {
            keys = ["|"];
            commands = [":search_inc "];
          }
          {
            keys = ["\\"];
            commands = [":search_glob "];
          }
          {
            keys = ["S"];
            commands = ["search_fzf"];
          }
          {
            keys = ["C"];
            commands = ["subdir_fzf"];
          }

          {
            keys = ["n"];
            commands = ["search_next"];
          }
          {
            keys = ["N"];
            commands = ["search_prev"];
          }

          {
            keys = ["s" "r"];
            commands = ["sort reverse"];
          }
          {
            keys = ["s" "l"];
            commands = ["sort lexical"];
          }
          {
            keys = ["s" "m"];
            commands = ["sort mtime"];
          }
          {
            keys = ["s" "n"];
            commands = ["sort natural"];
          }
          {
            keys = ["s" "s"];
            commands = ["sort size"];
          }
          {
            keys = ["s" "e"];
            commands = ["sort ext"];
          }

          {
            keys = ["m" "s"];
            commands = ["linemode size"];
          }
          {
            keys = ["m" "m"];
            commands = ["linemode mtime"];
          }
          {
            keys = ["m" "M"];
            commands = ["linemode size | mtime"];
          }
          {
            keys = ["m" "u"];
            commands = ["linemode user"];
          }
          {
            keys = ["m" "U"];
            commands = ["linemode user | group"];
          }
          {
            keys = ["m" "p"];
            commands = ["linemode perm"];
          }

          {
            keys = ["g" "r"];
            commands = ["cd /"];
          }
          {
            keys = ["g" "c"];
            commands = ["cd ~/.config"];
          }
          {
            keys = ["g" "d"];
            commands = ["cd ~/Downloads"];
          }
          {
            keys = ["g" "e"];
            commands = ["cd /etc"];
          }
          {
            keys = ["g" "h"];
            commands = ["cd ~/"];
          }
          {
            keys = ["?"];
            commands = ["help"];
          }
        ];
      };

      task_view = {
        keymap = [
          {
            keys = ["arrow_up"];
            commands = ["cursor_move_up"];
          }
          {
            keys = ["arrow_down"];
            commands = ["cursor_move_down"];
          }
          {
            keys = ["home"];
            commands = ["cursor_move_home"];
          }
          {
            keys = ["end"];
            commands = ["cursor_move_end"];
          }

          {
            keys = ["j"];
            commands = ["cursor_move_down"];
          }
          {
            keys = ["k"];
            commands = ["cursor_move_up"];
          }
          {
            keys = ["g" "g"];
            commands = ["cursor_move_home"];
          }
          {
            keys = ["G"];
            commands = ["cursor_move_end"];
          }

          {
            keys = ["w"];
            commands = ["show_tasks"];
          }
          {
            keys = ["escape"];
            commands = ["show_tasks"];
          }
        ];
      };

      help_view = {
        keymap = [
          {
            keys = ["arrow_up"];
            commands = ["cursor_move_up"];
          }
          {
            keys = ["arrow_down"];
            commands = ["cursor_move_down"];
          }
          {
            keys = ["home"];
            commands = ["cursor_move_home"];
          }
          {
            keys = ["end"];
            commands = ["cursor_move_end"];
          }

          {
            keys = ["j"];
            commands = ["cursor_move_down"];
          }
          {
            keys = ["k"];
            commands = ["cursor_move_up"];
          }
          {
            keys = ["g" "g"];
            commands = ["cursor_move_home"];
          }
          {
            keys = ["G"];
            commands = ["cursor_move_end"];
          }

          {
            keys = ["w"];
            commands = ["show_tasks"];
          }
          {
            keys = ["escape"];
            commands = ["show_tasks"];
          }
        ];
      };
    };
  };
}

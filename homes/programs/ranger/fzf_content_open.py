class fzf_content_open(Command):
    """
    :fzf_content_open
    Pre-requisites: fzf, rg, bat, awk, vim or neovim
    Using `rg` to search file content recursively in current directory.
    Filtering with `fzf` and preview with `bat`.
    Pressing `Enter` on target will open at line in (neo)vim.
    """

    def execute(self):
        import subprocess
        import os

        editor = os.environ["EDITOR"]
        # we should not recursively search through all file content from home directory
        if (self.fm.thisdir.path == self.fm.home_path):
            self.fm.notify("Searching from home directory is not allowed", bad=True)
            return
        fzf = self.fm.execute_command(
            'rg --line-number "${1:-.}" | fzf --delimiter \':\' \
                --preview \'bat --color=always --highlight-line {2} {1}\' \
                | awk -F \':\' \'{print "+"$2" "$1}\'',
            universal_newlines=True,stdout=subprocess.PIPE)

        stdout, _ = fzf.communicate()
        if fzf.returncode == 0:
            if len(stdout) < 2:
                return

            selected_line = stdout.split()[0]
            full_path = stdout.split()[1].strip()

            file_fullpath = os.path.abspath(full_path)
            file_basename = os.path.basename(full_path)

            if os.path.isdir(file_fullpath):
                self.fm.cd(file_fullpath)
            else:
                self.fm.select_file(file_fullpath)

            self.fm.execute_command(editor + " " + selected_line + " " + file_basename)

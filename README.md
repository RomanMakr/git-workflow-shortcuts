# Git Shortcuts for Bash

A collection of Bash functions for common Git operations, so you can run them without typing `git` before every command. Intended for Linux using Bash.

## Quick install

From the project root, install the script and shortcuts for your platform:

```bash
make install
# or
make linux
make mac
make windows
```

On Linux, `make linux` also installs `ginitrepo` as a standalone command in
`~/.local/bin` and adds that directory to `PATH` in `~/.bashrc`. Open a new
terminal (or run `source ~/.bashrc` once in the current one) before using it.

## Installation

1. Keep the `git-shortcuts` folder in your home directory. For example, it should be at `~/git-shortcuts/`.
2. Open your Bash configuration:

   ```bash
   nano ~/.bashrc
   ```

3. Add this line at the bottom of the file:

   ```bash
   source "$HOME/git-shortcuts/git-workflow-shortcuts.sh"
   ```

   If you saved the folder elsewhere, update the path.

4. Save (`Ctrl+O`, then `Enter`) and exit (`Ctrl+X`). Activate the shortcuts:

   ```bash
   source ~/.bashrc
   ```

## Linux VS Code terminal shortcuts

For Linux users, the repository includes a VS Code keybindings template at
[`vscode/keybindings.json`](./vscode/keybindings.json). To use it, open the
Command Palette, choose **Preferences: Open Keyboard Shortcuts (JSON)**, and
merge the template's entries into your personal `keybindings.json`. Do not
replace that file if it already contains your own bindings.

The same terminal shortcuts are supported in GNOME Terminal. Configure its
copy, paste, and select-all keys with:

```bash
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ select-all '<Control>a'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ copy '<Control>c'
gsettings set org.gnome.Terminal.Legacy.Keybindings:/org/gnome/terminal/legacy/keybindings/ paste '<Control>v'
```

For both terminals, add this line to `~/.inputrc` so Ctrl+X clears the
unsubmitted Bash command just like Ctrl+U:

```text
"\C-x": "\C-u"
```

Add the following to `~/.bashrc` so Ctrl+S interrupts commands instead of
pausing terminal output, and `reset` does not print the interrupt-key notice:

```bash
alias reset='reset -Q'

__restore_terminal_controls() {
    stty intr '^S' -ixon -echoctl 2>/dev/null
}

if [[ -t 0 ]]; then
    __restore_terminal_controls
    case ";${PROMPT_COMMAND:-};" in
        *";__restore_terminal_controls;"*) ;;
        *) PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND; }__restore_terminal_controls" ;;
    esac
fi
```

Open new terminal sessions after changing `~/.bashrc` or `~/.inputrc`.

| Shortcut | GNOME Terminal | VS Code integrated terminal |
|---|---|---|
| Ctrl+A | Select all terminal text | Select all terminal text |
| Ctrl+C | Copy selection | Copy selection; if nothing is selected, send the interrupt character |
| Ctrl+V | Paste | Paste |
| Ctrl+S | Interrupt the running command | Interrupt the running command |
| Ctrl+X | Clear typed Bash input from the start of the line to the cursor | Clear typed Bash input from the start of the line to the cursor |

Ctrl+C is configured for copying in GNOME Terminal, so use Ctrl+S to interrupt
a command there. VS Code keeps Ctrl+C's normal interrupt behavior when there is
no terminal selection. These VS Code keybindings apply only while the
integrated terminal has focus.

## Commands

| Command | Description | Example |
|---|---|---|
| `ginitrepo <remote-url>` | Initialize a repository, commit `README.md` as `first commit`, set the branch to `main`, and push to `origin` | `ginitrepo https://github.com/you/project.git` |
| `push_current_branch` | Push current branch to `origin` and set its upstream | `push_current_branch` |
| `pull_current_branch` | Pull current branch from its upstream, or from `origin` if no upstream is set | `pull_current_branch` |
| `commit "message"` | Create a Git commit with a message | `commit "Fix login bug"` |
| `gcb branch-name` | Create and switch to a new branch | `gcb feature-portfolio` |
| `gbD branch-name` | Delete a merged local branch safely | `gbD feature-portfolio` |
| `gbD_remote branch-name` | Delete a branch from `origin` | `gbD_remote feature-portfolio` |
| `gbD_force branch-name` | Force-delete a local branch | `gbD_force feature-portfolio` |
| `gmo` | Fetch `origin` and merge `origin/<current-branch>` into the current branch | `gmo` |
| `clipcopy [text]` | Copy text, or piped standard input, to the system clipboard | `printf 'hello' \| clipcopy` |
| `clippaste` | Write the system clipboard contents to standard output | `clippaste` |
| `gs` | Show Git status | `gs` |
| `gl` | Show the latest 10 commits | `gl` |
| `gb` | List local branches | `gb` |
| `gco branch-name` | Switch branches | `gco main` |
| `gd` | Show unstaged changes | `gd` |
| `ga file` | Stage a file | `ga lib/main.dart` |
| `gaa` | Stage all changes | `gaa` |
| `gcp commit-hash` | Cherry-pick a commit | `gcp abc1234` |

## Example workflow

Create and publish a new repository from a directory containing `README.md`:

```bash
ginitrepo https://github.com/RomanMakr/git-workflow-shortcuts.git
```

The command expects a repository with no commits and no configured `origin`. It commits only `README.md`; Git will reject the commit if your Git identity is not configured.

For an existing repository:

```bash
gs
ga lib/main.dart
commit "Add portfolio screen"
push_current_branch
```

Create a branch, make changes, then commit and push:

```bash
gcb feature-portfolio
# Make your changes
gaa
commit "Add portfolio screen"
push_current_branch
```

## Notes and safety

- Run these functions inside a Git repository.
- `push_current_branch` expects your remote to be named `origin`.
- `push_current_branch` uses `git push -u origin HEAD`, which pushes the current branch and sets its upstream.
- `pull_current_branch` uses the configured upstream when available. Otherwise, it pulls from `origin` using the current branch name.
- `gbD` only deletes a branch Git considers merged. `gbD_force` can discard unmerged work; use it carefully.
- `gbD_remote` deletes the named branch from the `origin` remote.
- `gmo` fetches `origin` before merging the remote-tracking branch with the current branch's name.
- These are Bash functions, not standalone programs. They are available after loading the script through `~/.bashrc`.
- Prefer hyphens in branch names, such as `feature-portfolio`, rather than spaces.

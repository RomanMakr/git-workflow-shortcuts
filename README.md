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

## Commands

| Command | Description | Example |
|---|---|---|
| `ginitrepo <remote-url>` | Initialize a repository, commit `README.md` as `first commit`, set the branch to `main`, and push to `origin` | `ginitrepo https://github.com/you/project.git` |
| `push_current_branch` | Push current branch to `origin` and set its upstream | `push_current_branch` |
| `pull_current_branch` | Pull current branch from its upstream, or from `origin` if no upstream is set | `pull_current_branch` |
| `gitcommit "message"` | Create a Git commit with a message | `gitcommit "Fix login bug"` |
| `gcb branch-name` | Create and switch to a new branch | `gcb feature-portfolio` |
| `gbD branch-name` | Delete a merged local branch safely | `gbD feature-portfolio` |
| `gbD_force branch-name` | Force-delete a local branch | `gbD_force feature-portfolio` |
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
gitcommit "Add portfolio screen"
push_current_branch
```

## Notes and safety

- Run these functions inside a Git repository.
- `push_current_branch` expects your remote to be named `origin`.
- `push_current_branch` uses `git push -u origin HEAD`, which pushes the current branch and sets its upstream.
- `pull_current_branch` uses the configured upstream when available. Otherwise, it pulls from `origin` using the current branch name.
- `gbD` only deletes a branch Git considers merged. `gbD_force` can discard unmerged work; use it carefully.
- These are Bash functions, not standalone programs. They are available after loading the script through `~/.bashrc`.
- Prefer hyphens in branch names, such as `feature-portfolio`, rather than spaces.

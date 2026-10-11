#!/usr/bin/env bash
# Git shortcuts for Bash. Load this file from ~/.bashrc.

# Push current branch to origin and set its upstream.
push_current_branch() {
    git push -u origin HEAD "$@"
}

# Pull current branch from its configured upstream, or origin/<branch> if none is set.
pull_current_branch() {
    local branch
    branch="$(git branch --show-current)" || return
    if [[ -z "$branch" ]]; then
        echo "Error: you are not currently on a branch (detached HEAD)." >&2
        return 1
    fi
    if git rev-parse --abbrev-ref --symbolic-full-name '@{u}' >/dev/null 2>&1; then
        git pull "$@"
    else
        git pull origin "$branch" "$@"
    fi
}

# Create a Git commit: gitcommit "Your commit message"
gitcommit() {
    if [[ $# -eq 0 ]]; then
        echo 'Usage: gitcommit "Your commit message"' >&2
        return 2
    fi
    git commit -m "$*"
}

commit() {
    gitcommit "$@"
}

# Initialize a repository, create its first commit, and publish it to origin.
ginitrepo() {
    if [[ $# -ne 1 ]]; then
        echo "Usage: ginitrepo <remote-url>" >&2
        return 2
    fi
    if [[ ! -f README.md ]]; then
        echo "Error: README.md was not found in the current directory." >&2
        return 1
    fi
    if git rev-parse --verify HEAD >/dev/null 2>&1; then
        echo "Error: the current repository already has a commit." >&2
        return 1
    fi
    if git remote get-url origin >/dev/null 2>&1; then
        echo "Error: remote 'origin' is already configured." >&2
        return 1
    fi

    git init || return
    git add README.md || return
    git commit -m "first commit" || return
    git branch -M main || return
    git remote add origin "$1" || return
    git push -u origin main
}

# Create and switch to a new branch: gcb feature-name
gcb() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gcb branch-name" >&2
        return 2
    fi
    git checkout -b "$*"
}

# Safely delete a merged local branch: gbD branch-name
gbD() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gbD branch-name" >&2
        return 2
    fi
    git branch -d "$@"
}

# Delete a remote branch from origin: gbD_remote branch-name
gbD_remote() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gbD_remote branch-name" >&2
        return 2
    fi
    git push origin --delete "$@"
}

# Force-delete a local branch. Use carefully: unmerged work may be lost.
gbD_force() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gbD_force branch-name" >&2
        return 2
    fi
    git branch -D "$@"
}

# Fetch origin and merge the current branch's remote-tracking branch.
gmo() {
    local branch
    branch="$(git branch --show-current)" || return
    if [[ -z "$branch" ]]; then
        echo "Error: you are not currently on a branch (detached HEAD)." >&2
        return 1
    fi
    git fetch origin || return
    git merge "origin/$branch" "$@"
}

# Fetch origin and merge its main branch into the current branch.
gmerge_main() {
    git fetch origin || return
    git merge origin/main "$@"
}

# Create a pull request targeting main with generated title and description.
gpr() {
    gh pr create --base main --fill "$@"
}

# Copy text or standard input to the system clipboard.
clipcopy() {
    if [[ $# -gt 0 ]]; then
        printf '%s' "$*" | _gitws_clipboard_copy
        return
    fi
    if [[ -t 0 ]]; then
        echo "Usage: clipcopy [text] (or pipe text to clipcopy)" >&2
        return 2
    fi
    _gitws_clipboard_copy
}

_gitws_clipboard_copy() {
    if command -v wl-copy >/dev/null 2>&1; then
        wl-copy
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard
    elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --input
    else
        echo "Error: install wl-clipboard, xclip, or xsel to use the clipboard." >&2
        return 127
    fi
}

# Write the system clipboard contents to standard output.
clippaste() {
    if command -v wl-paste >/dev/null 2>&1; then
        wl-paste --no-newline
    elif command -v xclip >/dev/null 2>&1; then
        xclip -selection clipboard -o
    elif command -v xsel >/dev/null 2>&1; then
        xsel --clipboard --output
    else
        echo "Error: install wl-clipboard, xclip, or xsel to use the clipboard." >&2
        return 127
    fi
}

# Common shortcuts
gs()  { git status "$@"; }
gl()  { git log --oneline -10 "$@"; }
gb()  { git branch "$@"; }
gco() { git checkout "$@"; }
gd()  { git diff "$@"; }
ga()  { git add "$@"; }
gaa() { git add -A "$@"; }
gcp() { git cherry-pick "$@"; }

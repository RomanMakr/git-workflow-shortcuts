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

# Force-delete a local branch. Use carefully: unmerged work may be lost.
gbD_force() {
    if [[ $# -eq 0 ]]; then
        echo "Usage: gbD_force branch-name" >&2
        return 2
    fi
    git branch -D "$@"
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

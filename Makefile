SHELL := /bin/bash

SCRIPT := $(CURDIR)/git-workflow-shortcuts.sh
SOURCE := source "$(SCRIPT)"
LOCAL_BIN := $(HOME)/.local/bin
PATH_LINE := export PATH="$(LOCAL_BIN):$$PATH"

.PHONY: help install linux mac windows win install-linux install-macos install-windows uninstall

help:
	@printf '%s\n' "Git workflow shortcuts"
	@printf '%s\n' "  make install      Auto-detect OS and install"
	@printf '%s\n' "  make linux        Install ginitrepo and shortcuts on Linux"
	@printf '%s\n' "  make mac          Add source line to ~/.zshrc"
	@printf '%s\n' "  make windows      Add source line to ~/.bashrc (Git Bash/MSYS2)"
	@printf '%s\n' "  make uninstall    Remove the source line from shell profiles"

install:
	@case "$$(uname -s)" in \
		Linux) $(MAKE) linux ;; \
		Darwin) $(MAKE) mac ;; \
		MINGW*|MSYS*|CYGWIN*) $(MAKE) windows ;; \
		*) echo "Unsupported OS: $$(uname -s)" >&2; exit 1 ;; \
	esac

add-profile = @profile="$(1)"; [ -f "$$profile" ] || touch "$$profile"; grep -Fq '$(SOURCE)' "$$profile" || printf '%s\n' '' '$(SOURCE)' >> "$$profile"; echo "Installed in $$profile"

linux:
	@mkdir -p "$(LOCAL_BIN)"
	@printf '%s\n' '#!/usr/bin/env bash' 'source "$(SCRIPT)"' 'ginitrepo "$$@"' > "$(LOCAL_BIN)/ginitrepo"
	@chmod +x "$(LOCAL_BIN)/ginitrepo"
	@profile="$(HOME)/.bashrc"; [ -f "$$profile" ] || touch "$$profile"; \
	grep -Fq '$(PATH_LINE)' "$$profile" || printf '%s\n' '$(PATH_LINE)' >> "$$profile"; \
	grep -Fq '$(SOURCE)' "$$profile" || printf '%s\n' '' '$(SOURCE)' >> "$$profile"; \
	echo "Installed ginitrepo in $(LOCAL_BIN) and shortcuts in $$profile"
	@echo "Open a new terminal, or run: source ~/.bashrc"

mac:
	$(call add-profile,$(HOME)/.zshrc)
	@echo "Reload it with: source ~/.zshrc"

windows:
	$(call add-profile,$(HOME)/.bashrc)
	@echo "Reload it with: source ~/.bashrc"

install-linux: linux
install-macos: mac
install-windows: windows
win: windows

uninstall:
	@for profile in "$(HOME)/.bashrc" "$(HOME)/.zshrc" "$(HOME)/.profile"; do \
		[ -f "$$profile" ] || continue; \
		tmp="$$(mktemp)"; \
		grep -Fv '$(SOURCE)' "$$profile" > "$$tmp" || true; \
		mv "$$tmp" "$$profile"; \
		echo "Removed from $$profile"; \
	done

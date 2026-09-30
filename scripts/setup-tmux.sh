#!/usr/bin/env bash

set -euo pipefail

TMUX_PLUGIN_DIR="${HOME}/.tmux/plugins"
TPM_DIR="${TMUX_PLUGIN_DIR}/tpm"

command -v git >/dev/null 2>&1 || {
	echo "error: git is required"
	exit 1
}

command -v tmux >/dev/null 2>&1 || {
	echo "error: tmux is required"
	exit 1
}

if [[ ! -f "${HOME}/.tmux.conf" ]]; then
	echo "error: ~/.tmux.conf does not exist"
	echo "run 'stow tmux' first"
	exit 1
fi

mkdir -p "${TMUX_PLUGIN_DIR}"

if [[ ! -d "${TPM_DIR}" ]]; then
	git clone https://github.com/tmux-plugins/tpm "${TPM_DIR}"
else
	echo "TPM already installed."
fi

echo "To finish setting tmux up, open up a new tmux env."
echo "Run tmux, then hit C-a + I to install packages with TPM"

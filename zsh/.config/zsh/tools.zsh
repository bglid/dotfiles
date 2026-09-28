[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

[ -f "$HOME/.local/bin/env" ] && source "$HOME/.local/bin/env"

eval "$(uv generate-shell-completion zsh)"
eval "$(direnv hook zsh)"
eval "$(zoxide init zsh --cmd cd)"

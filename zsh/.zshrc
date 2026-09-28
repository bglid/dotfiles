# Path to Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="dracula" # TODO gonna change
DRACULA_DISPLAY_TIME=1 #Displays Time
DRACULA_TIME_FORMAT="%-H:%M"
DRACULA_DISPLAY_CONTEXT=1
DRACULA_DISPLAY_FULL_CWD=1

plugins=(
    git
)

source "$ZSH/oh-my-zsh.sh"
source "$HOME/.config/zsh/aliases.zsh"
source "$HOME/.config/zsh/env.zsh"
source "$HOME/.config/zsh/tools.zsh"

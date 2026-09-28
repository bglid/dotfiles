##### Aliases!
alias man="batman"
alias cr='cargo run'
alias cb='cargo build'
alias ct='cargo test'

alias grep='rg'

# Crabtree alias
alias ctree='crabtree'

# For espressif
[[ -f "$HOME/esp/esp-idf/export.sh" ]] &&
    alias get_idf='. "$HOME/esp/esp-idf/export.sh"'


export PATH="$HOME/.local/bin:$PATH"
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

export NVM_DIR="$HOME/.nvm"

[[ -d /usr/local/cuda/lib64 ]] &&
    export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+$LD_LIBRARY_PATH:}/usr/local/cuda/lib64"

[[ -d /usr/local/cuda-12.9/bin ]] &&
    export PATH="/usr/local/cuda-12.9/bin:$PATH"


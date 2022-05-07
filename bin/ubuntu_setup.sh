################################################################
#### Install
################################################################

# To sort packages, use "echo '[PACKAGES]' | sed 's/ /\n/g' | sort | sed -e ':loop; N; $!b loop; s/\n/ /g'"
# When an error occurs, use "sudo dpkg -i --force-all [PACKAGE-FILE]..."
sudo apt update && sudo apt upgrade -y
sudo apt install -y \
aria2 bat build-essential fd-find fzf hub peco tmux unzip zsh

# Zinit
bash -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"

# Go
if !(type go > /dev/null 2>&1); then
    GO_FILE_NAME=go1.18.1.linux-amd64.tar.gz

    aria2c https://go.dev/dl/$GO_FILE_NAME
    sudo rm -rf /usr/local/go
    sudo tar -C /usr/local -xzf $GO_FILE_NAME
    rm $GO_FILE_NAME
    export PATH=/usr/local/go/bin:$PATH
fi

# Rust
if !(type rustup > /dev/null 2>&1); then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
    source $HOME/.cargo/env
fi

# exa
if !(type exa > /dev/null 2>&1); then
    cargo install exa
fi

# ghq
if !(type ghq > /dev/null 2>&1); then
    go install github.com/x-motemen/ghq@latest
fi

# hexyl
if !(type hexyl > /dev/null 2>&1); then
    cargo install hexyl
fi

# hyperfine
if !(type hyperfine > /dev/null 2>&1); then
    cargo install hyperfine
fi

# procs
if !(type procs > /dev/null 2>&1); then
    cargo install procs
fi

# ripgrep
if !(type procs > /dev/null 2>&1); then
    cargo install ripgrep
fi


################################################################
#### Others
################################################################

# Set up a bat -> batcat symlink
if !(type bat > /dev/null 2>&1); then
    mkdir -p ~/.local/bin
    ln -s /usr/bin/batcat ~/.local/bin/bat
fi

chsh -s /bin/zsh
git config --global init.defaultBranch main

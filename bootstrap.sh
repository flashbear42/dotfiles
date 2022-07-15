#! /usr/bin/env sh

. ./scripts/functions.sh

info "Prompting for sudo password..." 
if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
        success "Sudo credentials updated."
    else
        error "Failed to obtain sudo credentials."
fi


# =============================================================================
# Xcode commandline tools and rosetta 2
# =============================================================================
info "Installing Xcode command line tools..."
if xcode-select --print-path &>/dev/null; then
    success "Xcode command line tools already installed."
elif xcode-select --install &>/dev/null; then
    success "Done."
else
    error "Fail to install Xcode command line tools."
fi

info "Installing Rosetta 2..."
#sudo softwareupdate --install-rosetta --agree-to-license
success "Done."

# =============================================================================
# homebrew
# =============================================================================
info "Installing Homebrew..."
if ! command -v brew >/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
    success "Done."
else
    success "Homebrew already installed."
fi

[ -d "/opt/homebrew" ] && HOMEBREW_PREFIX="/opt/homebrew"
eval "$($HOMEBREW_PREFIX/bin/brew shellenv)"


# =============================================================================
# homebrew bundles
# =============================================================================
info "Installing homebrew packages..."
brew bundle --file Brewfile
success "Done."

# =============================================================================
# Set base PATHs
# =============================================================================
SOURCE="$(realpath -m .)"
HOME="$(realpath -m ~)"

# =============================================================================
# fish
# =============================================================================
FISH_PATH="$HOME/.config/fish"
info "Configuring fish to $FISH_PATH..."

substep_info "Create fish config folders"
if [ ! -d "$FISH_PATH/conf.d" ]; then
    mkdir -p "$FISH_PATH/conf.d"
fi
if [ ! -d "$FISH_PATH/functions" ]; then
    mkdir -p "$FISH_PATH/functions"
fi
if [ ! -d "$FISH_PATH/completions" ]; then
    mkdir -p "$FISH_PATH/completions"
fi
substep_success "Done"

find "fish" -name "*.fish" | sed -e "s/^fish\///" | while read fn; do
    echo $fn
    symlink "$SOURCE/fish/$fn" "$FISH_PATH/$fn"
done

set_fish_shell() {
    if grep --quiet fish <<< "$SHELL"; then
        success "Fish shell is already set up."
    else
        substep_info "Adding fish executable to /etc/shells"
        if grep --fixed-strings --line-regexp --quiet "$(which fish)" /etc/shells; then
            substep_success "Fish executable already exists in /etc/shells."
        else
            if sudo bash -c "echo "$(which fish)" >> /etc/shells"; then
                substep_success "Fish executable added to /etc/shells."
            else
                hsubstep_error "Failed adding Fish executable to /etc/shells."
                return 1
            fi
        fi

        substep_info "Changing shell to fish"
        if chsh -s "$(which fish)"; then
            substep_success "Default shell changed to fis."
        else
            substep_error "Failed changing default shell to fish"
            return 2
        fi

        sebstep_info "Set default theme to Nord"
        fish_config theme save "Nord"
    fi
}

# Set fish to default shell
if set_fish_shell; then
    success "Done."
else
    error "Failed setting up fish shell."
fi
clear_broken_symlinks "$FISH_PATH"


# =============================================================================
# git
# =============================================================================
GIT_PATH=$HOME
info "Configuring git to $GIT_PATH..."
#find "git" -type f -name "git*" -exec basename {} \; | sed -e "s/^git/.git/" | while read fn; do
find "git" -type f -name "git*" -exec basename {} \; | while read fn; do
    echo $fn
    symlink "$SOURCE/git/$fn" "$GIT_PATH/.$fn" 
done
success "Done"

# =============================================================================
# vim
# =============================================================================
VIM_PATH=$HOME
info "Configuring vim to $VIM_PATH..."
symlink "$SOURCE/vim/vimrc" "$VIM_PATH/.vimrc"
success "Done."

# =============================================================================
# emacs
# =============================================================================
EMACS_PATH=$HOME
info "Configuring emacs to $EMACS_PATH..."
success "Done."


# =============================================================================
# karabiner
# =============================================================================
KARABINER_PATH="$HOME/.config/karabiner"
info "Configuring karabiner-elements to $KARABINER_PATH..."
if [ ! -d "$KARABINER_PATH" ]; then
    substep_info "Create karabiner-elements folder:"
    mkdir -p "$KARABINER_PATH"
    substep_success "Done."
fi

find "karabiner" -type f -name "*.json" -exec basename {} \; | while read fn; do
    symlink "$SOURCE/karabiner/$fn" "$KARABINER_PATH/$fn"
done
success "Done."

#clear_broken_symlinks "$HOME/.config"


# =============================================================================
# asdf
# =============================================================================
info "Configurating asdf"
substep_info "Install plugins"
asdf plugin-add python
asdf plugin add nodejs https://github.com/asdf-vm/asdf-nodejs.git
asdf plugin-add rust https://github.com/code-lever/asdf-rust.git
asdf plugin add ruby https://github.com/asdf-vm/asdf-ruby.git
substep_success "Done."
success "Done."


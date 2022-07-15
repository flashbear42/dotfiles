if status is-interactive
    # Commands to run in interactive sessions can go here
end

if status --is-login
    # Load pre-defined abbreviations
    source $HOME/.config/fish/conf.d/abbr.fish
end

# homebrew
eval "$(/opt/homebrew/bin/brew shellenv)"

# asdf
set -x ASDF_DATA_DIR "$HOME/.config/asdf"
set -x ASDF_CONFIG_FILE "$HOME/.config/asdf/.asdfrc"

source /opt/homebrew/opt/asdf/libexec/asdf.fish

# difftastcc
set -x DFT_TAB_WIDTH 4
set -x DFT_SYNTAX_HIGHLIGHT on


# Setup starship.rs
starship init fish | source


source /usr/share/cachyos-fish-config/cachyos-config.fish

# fnm (Fast Node Manager)
fnm env --use-on-cd --shell fish | source

# local bin
if not string match -q -- "$HOME/.local/bin" $PATH
  set -gx PATH "$HOME/.local/bin" $PATH
end

# overwrite greeting
# potentially disabling fastfetch
#function fish_greeting
#    # smth smth
#end

# opencode
fish_add_path /home/fiidev/.opencode/bin

fish_add_path /home/fiidev/.spicetify

# markdown viewer
alias md="glow"

# default editor (yazi fallback for text files, git, dmesg, etc.)
set -gx EDITOR nvim
set -gx VISUAL nvim

# pnpm
set -gx PNPM_HOME "/home/fiidev/.local/share/pnpm"
if not string match -q -- "$PNPM_HOME/bin" $PATH
  set -gx PATH "$PNPM_HOME/bin" $PATH
end
# pnpm end
set -gx PATH ~/go/bin $PATH
fish_add_path $HOME/.local/share/JetBrains/Toolbox


# Added by Antigravity CLI installer
set -gx PATH "/home/fiidev/.local/bin" $PATH

# Kitty Theme Switcher Alias
alias kitty-theme='~/.config/kitty/set-theme.sh'

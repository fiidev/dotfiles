# Dotfiles

Personal desktop configuration for Hyprland on CachyOS (Arch Linux).

## Overview

- Window Manager: Hyprland (Lua configuration via hyprland.lua)
- Bar: Waybar
- Application Launcher: Rofi
- Notification Daemon: Mako
- Terminal: Kitty
- Shell: Fish with Starship prompt
- System Info: Fastfetch
- Lockscreen & Idle: Hyprlock & Hypridle
- Fonts: Plus Jakarta Sans (interface), CommitMono Nerd Font (monospace)

## Repository Structure

```
dotfiles/
├── .config/
│   ├── fastfetch/     # Fastfetch system info configuration
│   ├── fish/          # Fish shell configuration and completions
│   ├── gtk-3.0/       # GTK 3 theme and font settings
│   ├── gtk-4.0/       # GTK 4 theme and font settings
│   ├── hypr/          # Hyprland compositor, idle, lock, and custom scripts
│   ├── kitty/         # Kitty terminal emulator configuration
│   ├── mako/          # Mako notification daemon configuration
│   ├── rofi/          # Rofi launcher configurations, themes, and scripts
│   ├── starship.toml  # Starship prompt configuration
│   └── waybar/        # Waybar bar configuration, styles, and scripts
└── walls/             # Desktop wallpapers
```

## Key Bindings Summary

- Super + Space: Application launcher (Rofi)
- Super + Return: Terminal (Kitty)
- Super + E: File Manager (Nautilus)
- Super + C: Code Editor (VS Code)
- Super + V: Clipboard history manager
- Super + W: Wallpaper picker
- Super + Q: Close active window
- Super + F: Toggle window fullscreen
- Super + Shift + T: Toggle window floating
- Super + Shift + S: Region screenshot to clipboard

## Installation

Clone the repository to your home directory:

```bash
git clone https://github.com/fiidev/dotfiles.git ~/dotfiles
```

Symlink or copy the configurations into your `~/.config` folder:

```bash
cp -r ~/dotfiles/.config/* ~/.config/
cp -r ~/dotfiles/walls ~/walls
```

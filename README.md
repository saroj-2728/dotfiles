# dotfiles-hyprland

💠 Dotfiles for my EndeavourOS setup using Hyprland window manager.

This repository contains configuration files for a minimal and customized Linux desktop environment. It is focused on performance, aesthetics, and productivity.

## 🖥️ System Details

- **OS**: EndeavourOS (Arch-based)
- **WM**: Hyprland
- **Shell**: fish
- **Terminal**: kitty
- **Bar**: waybar
- **App launcher**: rofi

## 📁 Included Configurations

```
dotfiles-hyprland/
├── .config/
│   ├── backgrounds/     # Wallpapers used in the setup
│   ├── hypr/            # Hyprland configuration files
│   ├── kitty/           # Kitty terminal config
│   ├── rofi/            # Rofi launcher theme and layout
│   └── waybar/          # Waybar status bar config
└── README.md
```


## 📦 Installed Packages for Hyprland Setup

These are the main packages installed on this system to support the Hyprland environment, including fonts, utilities, and tools:

### From Official Repositories (`pacman`):

- `hyprland` — The window manager itself  
- `rofi` — Application launcher  
- `waybar` — Status bar for Wayland  
- `neovim` — Terminal text editor  
- `alacritty` — GPU-accelerated terminal emulator  
- `kitty` — Terminal emulator
- `neofetch` — System information tool  
- `ttf-font-awesome` — Font Awesome icons  
- `ttf-jetbrains-mono-nerd` — JetBrains Mono Nerd Font  
- `ttf-noto-fonts` — Noto font family  
- `yay` — AUR helper  
- `pavucontrol` — PulseAudio volume control  
- `blueman` — Bluetooth manager  
- `network-manager-applet` — Network management tray applet  
- `networkmanager` — Network management daemon  
- `brightnessctl` — Backlight brightness control  

### From AUR (`yay`):

- `hyprpaper` — Wallpaper manager for Hyprland  
- `hypridle` — Screen idle manager  
- `hyprlock` — Screen locker for Hyprland  
- `hyprshot` — Screenshot tool for Hyprland  
- `swaync` — Notification client for Wayland  
- `oh-my-posh` — Prompt theming engine for shell  
- `ttf-nerd-fonts-symbols` — Nerd Fonts symbols package  
- `ttf-cascadia-code-nerd` — Cascadia Code Nerd Font  


## 🚀 Usage

To apply these configurations, copy or symlink the config files to your `~/.config` directory. For example, using copy:

```bash
cp -r .config/* ~/.config/
```
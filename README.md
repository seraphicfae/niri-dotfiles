# My Niri dotfiles

Thanks to:
- <u>[Catppuccin](https://github.com/catppuccin)</u> for the amazing themes
- <u>[Adi1090x](https://github.com/adi1090x/rofi/)</u> for the base rofi config

---

## Showcase
https://github.com/user-attachments/assets/25b80fc7-52d7-4830-9999-8a66079345f3

---

## Quick Install:
> [!WARNING]
> Don't run random scripts blindly

```bash
git clone https://github.com/seraphicfae/niri-dotfiles
cd niri-dotfiles
./setup.sh
```

---

## Manual Install: (Advanced users)

### Dependencies

```bash
paru -S --needed --noconfirm \
awww-bin blueman breeze btop cava fastfetch ffmpegthumbnailer gvfs-mtp hyprlock imagemagick imv \
inter-font kitty libnotify ly mako matugen mpv nautilus niri noto-fonts-cjk noto-fonts-emoji \
papirus-icon-theme pavucontrol polkit-kde-agent qt5-wayland qt6-wayland qt6ct-kde rofi starship \
ttf-jetbrains-mono-nerd waybar wl-clipboard xdg-desktop-portal-gnome xdg-desktop-portal-gtk \
xwayland-satellite zed zsh zsh-autosuggestions zsh-syntax-highlighting
```

#### Steps
```bash
cd niri-dotfiles

cp -r .config/* "$HOME/.config/"

cp -r .local/bin/* "$HOME/.local/bin/"

cp -r .local/share/* "$HOME/.local/share/"

cp -r Pictures/ "$HOME/Pictures"

ln -sf ~/.local/share/themes/Orchis-Pink-Dark/gtk-4.0/* "$HOME/.config/gtk-4.0"
```

#### Finalizing
```bash
sudo systemctl enable ly@tty2.service

chsh -s /usr/bin/zsh

echo 'export ZDOTDIR="$HOME/.config/zsh"' > "$HOME/.zshenv"

reboot
```

---

## FAQ / Common Issues
**My temperature module doesn’t appear in waybar?** \
Look in `config.jsonc` and set it to your correct thermal zone.

**My fonts/icons look weird/don't show** \
Ensure you have: `inter-font ttf-jetbrains-mono-nerd`
These are required fonts you will need.

**How to setup my wallpaper?** \
`Super + W` and choose which image you want.

**How to get fastfetch to display images; not working** \
I have no clue, it feels random when it works or not, the git version works better.

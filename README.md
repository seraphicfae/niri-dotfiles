# My Niri dotfiles

Thanks to:
- <u>[Catppuccin](https://github.com/catppuccin)</u> for the amazing themes
- <u>[Adi1090x](https://github.com/adi1090x/rofi/)</u> for the incredible Rofi setup

---

## Showcase
https://github.com/user-attachments/assets/c7f45470-5c41-46e4-88f0-6dd9a8296cc3

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
blueman bluez-utils breeze catppuccin-sddm-theme-mocha cava fastfetch ffmpegthumbnailer gvfs-mtp hyprlock \
kitty mako matugen mission-center mpv nautilus network-manager-applet niri noto-fonts-cjk noto-fonts-emoji \
noto-fonts-extra pantheon-polkit-agent papirus-icon-theme pwvucontrol qt5-wayland qt6-wayland qt6ct-kde \
rofi rose-pine-cursor starship swww ttf-jetbrains-mono-nerd viewnior waybar wl-clip-persist wl-clipboard \
xdg-desktop-portal-gnome xdg-desktop-portal-gtk xwayland-satellite zed zsh imagemagick libnotify
```

#### Steps
```bash
cd niri-dotfiles

cp -r .config/* "$HOME/.config/"

cp -r .local/bin/* "$HOME"/.local/bin/

cp -r .local/share/* "$HOME"/.local/share/

cp -r Pictures/wallpapers/wallpaper_01.png "$HOME"/.local/state/current_wallpaper

cp -r Pictures/ "$HOME"/Pictures
```

#### Finalizing
```bash
sudo systemctl enable NetworkManager bluetooth sddm

echo -e "[Theme]\nCurrent=catppuccin-mocha-mauve" | sudo tee /etc/sddm.conf

git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.config/zsh/antidote"

chsh -s /usr/bin/zsh

export ZDOTDIR="$HOME/.config/zsh"

reboot
```

---

## FAQ / Common Issues
**My temperature module doesn’t appear in waybar?** \
Look in `config.jsonc` and set it to your correct thermal zone.

**MPRIS module is empty** \
It only shows when media is playing.

**My icons look weird/dont show** \
Download JetBrainsMono Nerd Font with pacman.

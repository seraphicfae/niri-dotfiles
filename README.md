# My Niri dotfiles

Thanks to:
- <u>[Catppuccin](https://github.com/catppuccin)</u> for the amazing themes
- <u>[Adi1090x](https://github.com/adi1090x/rofi/)</u> for the incredible Rofi setup

---

## Showcase
https://github.com/user-attachments/assets/d159864f-f5bd-4839-ad23-f3aa0a798239

---

## Quick Install:
> **Don't run random scripts blindly**

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
kitty mako matugen-bin mission-center mpv nautilus network-manager-applet niri noto-fonts-cjk noto-fonts-emoji \
noto-fonts-extra pantheon-polkit-agent papirus-icon-theme pwvucontrol qt5-wayland qt6-wayland qt6ct-kde \
rofi rose-pine-cursor starship swww ttf-jetbrains-mono-nerd viewnior waybar wl-clip-persist wl-clipboard \
xdg-desktop-portal-gnome xdg-desktop-portal-gtk xwayland-satellite zed zsh
```

#### Steps
```bash
cd niri-dotfiles

cp -rb .config/* "$HOME/.config/"
cp -rb .local/{bin,share} "$HOME/.local/"
```

### QoL/Extra (Recommended, but not need)
```bash
cp -r $HOME/.local/share/wallpapers/wallpaper_01.png $HOME/.local/state/current_wallpaper
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
**My temperature module doesn’t appear in the waybar?** \
Look in waybar and set it to your correct thermal zone.

**MPRIS module is empty** \
It only shows when media is playing.

**My icons look weird/dont show** \
With your package manager, download JetBrainsMono Nerd Font.

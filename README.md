# My Niri dotfiles

Thanks to:
- <u>[Catppuccin](https://github.com/catppuccin)</u> for the amazing themes
- <u>[Adi1090x](https://github.com/adi1090x/rofi/)</u> for the base rofi config

---

## Showcase
https://github.com/user-attachments/assets/ff2ca8f8-5f03-4c02-9119-728a27b24416

---

## Quick Install:
> [!WARNING]
> Don't run random scripts blindly

Manual and scripted install are meant to be installed on a new system.
I recommend you do the manual install on a pre-existing arch system.

```bash
git clone https://github.com/seraphicfae/niri-dotfiles
cd niri-dotfiles
./setup.sh
```

---

## Manual Install: (Advanced users)

### Dependencies

```bash
sudo pacman -S \
awww adw-gtk-theme blueman breeze-cursors breeze-icons fastfetch ffmpegthumbnailer \
hyprlock imagemagick imv inter-font kitty kvantum libnotify ly mako matugen mpv \
nautilus niri noto-fonts-cjk noto-fonts-emoji papirus-icon-theme pavucontrol \
qt6-wayland qt6ct rofi starship ttf-jetbrains-mono-nerd waybar wl-clipboard \
xdg-desktop-portal-gnome xdg-desktop-portal-gtk xwayland-satellite zed zenity \
zsh-autosuggestions zsh-syntax-highlighting
```

#### Steps
```bash
cd niri-dotfiles

cp -r .config/* "$HOME/.config/"

cp -r .local/bin/* "$HOME/.local/bin/"

cp -r .local/share/* "$HOME/.local/share/"

cp -r Pictures/ "$HOME/Pictures"

gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface font-name 'Inter 11'
gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
gsettings set org.gnome.desktop.interface cursor-size '24'
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

ln -sf /usr/share/themes/adw-gtk3/gtk-4.0/libadwaita.css "$HOME/.config/gtk-4.0/"
```

#### Finalizing
```bash
sudo systemctl enable ly@tty2
systemctl --user add-wants niri.service mako
systemctl --user add-wants niri.service waybar
systemctl --user add-wants niri.service awww-daemon

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

**My screen is grey/there's no wallpaper!** \
`Super + W` and choose which wallpaper you want.

**My Display Manager is black/can't log in** \
This is likely due to multiple display managers active (Sddm, Greeter, etc). \
Press `alt + ctrl + f3` to switch to a different tty, and disable your old display manager.

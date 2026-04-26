# My Niri dotfiles

Thanks to:
- <u>[Catppuccin](https://github.com/catppuccin)</u> for the amazing themes
- <u>[Adi1090x](https://github.com/adi1090x/rofi/)</u> for the base rofi config

---

## Showcase
https://github.com/user-attachments/assets/f669cc6b-0aa4-4335-ac2b-7ba5d41a7f69

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
paru -S --needed --noconfirm \
awww adw-gtk-theme blueman breeze fastfetch ffmpegthumbnailer gvfs-mtp hyprlock \
imagemagick imv inter-font kitty libnotify ly mako matugen mpv nautilus niri \
noto-fonts-cjk noto-fonts-emoji papirus-icon-theme pavucontrol polkit-kde-agent \
qt6-wayland qt6ct-kde rofi starship ttf-jetbrains-mono-nerd waybar wl-clipboard \
xdg-desktop-portal-gnome xdg-desktop-portal-gtk xwayland-satellite zed zsh \
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

sudo ln -sf /usr/share/themes/adw-gtk3/gtk-4.0/libadwaita.css "$HOME/.config/gtk-4.0/"
```

#### Finalizing
```bash
sudo systemctl enable ly@tty2
systemctl --user add-wants niri.service plasma-polkit-agent  
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

**How to setup my wallpaper?** \
`Super + W` and choose which image you want.

**My Display Manager is black/can't log in** \
This is likely due to multiple display managers active (Sddm, Greeter, etc). \
Press `alt + ctrl + f3` to switch to a different tty, and disable your old display manager.

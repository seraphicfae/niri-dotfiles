# My niri dotfiles with Noctalia shell

---

## Showcase
![video](https://seraphicfae.dev/_astro/niri-showcase.8rsYjD3O.webm)

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
adw-gtk-theme breeze ddcutil fastfetch ffmpegthumbnailer \
imagemagick imv inter-font kitty libnotify ly mpv niri \
noctalia noto-fonts-cjk noto-fonts-emoji papirus-icon-theme \
qt6-wayland starship ttf-jetbrains-mono-nerd wl-clipboard \
xdg-desktop-portal-gnome xdg-desktop-portal-gtk xwayland-satellite \
zed zsh-autosuggestions zsh-syntax-highlighting
```

#### Steps
```bash
cd niri-dotfiles

cp -r .config/* "$HOME/.config/"

cp -r .local/share/* "$HOME/.local/share/"

cp -r .local/state/* "$HOME/.local/state/"

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
systemctl --user add-wants niri.service noctalia

chsh -s /usr/bin/zsh

echo 'export ZDOTDIR="$HOME/.config/zsh"' > "$HOME/.zshenv"

reboot
```

---

## FAQ / Common Issues
**The screen recording keybind isn't working!** \
Install wl-screenrec via cargo or the AUR.

**My screen is grey/there's no wallpaper!** \
`Super + W` and choose which wallpaper you want!

**My Display Manager is black/can't log in** \
This is likely due to multiple display managers active (Sddm, Greeter, etc). \
Press `alt + ctrl + f3` to switch to a different tty, and disable your old display manager.

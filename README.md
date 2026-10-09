# My niri dotfiles with Noctalia shell

---

## Showcase

https://github.com/user-attachments/assets/9dc9ab6c-8d8a-4e98-a2fc-0bb286a86cf4

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

## Goals and scope of my dotfiles

- Avoid writing to root and opt for local/user changes (besides packages).
- Intentionally stay minimal and let the user customize their choices.
- Follow XDG Base directory specification, and use systemd whenever possible.
- Sensible configs for apps, niri, and related tooling (scripts).
- Avoid the AUR whenever possible, and as much as possible.

Even though these are my dotfiles, I try to keep out changes that would only 
make sense on my machine, and may break configs for others. I created the SKIP ME
section in setup.sh for this very reason. I do not want my dotfiles to be intrusive
on user's home directory. While you can install these on a prebuilt system, if you blindly 
paste commands, you could break your system. This is a problem with every dotfile,
but I try to minimize this issue when possible. I also avoid installing paru/yay because most users
don't read PKGBUILDs and blindly run untrusted scripts on their system. Qt6ct-kde is the
exception to this. I want Kcolorscheme with Qt6, but the [pull request in Qt6ct](https://www.opencode.net/trialuser/qt6ct/-/merge_requests/9) has remained
open for over a year. I encourge the reader of this to make the maintainer more aware of this feature.

## Manual Install: (Advanced users)

### Dependencies

```bash
sudo pacman -S \
alacritty adw-gtk-theme breeze ddcutil fastfetch ffmpegthumbnailer \
imagemagick imv inter-font libnotify ly mpv niri noctalia \
noto-fonts-cjk noto-fonts-emoji papirus-icon-theme qt6-wayland \
starship ttf-jetbrains-mono-nerd wl-clipboard xdg-desktop-portal-gnome \
xdg-desktop-portal-gtk xwayland-satellite zed zsh-autosuggestions \
zsh-syntax-highlighting
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

**Note for Cachyos** \
Due to CachyOS using a mix of custom repos for packages, \
it's likely to not work well with the script. Use at your own risk.

**The screen recording keybind isn't working!** \
Install wl-screenrec via cargo or the AUR.

**My screen is grey/there's no wallpaper!** \
`Super + W` and choose which wallpaper you want!

**My Display Manager is black/can't log in** \
This is likely due to multiple display managers active (Sddm, Greeter, etc). \
Press `alt + ctrl + f3` to switch to a different tty, and disable your old display manager.

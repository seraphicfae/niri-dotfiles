#!/usr/bin/env bash

# Creator : Mei Mei | https://github.com/seraphicfae/niri-dotfiles
# idiot proof install script. Feel free to adapt for your own dotfiles

# ────────────────[ Top Level Functions ]────────────────

fail() { printf "\e[1;31m[  NO  ] %s \e[0m\n" "$@"; }
okay() { printf "\e[1;32m[  OK  ] %s \e[0m\n" "$@"; }
warn() { printf "\e[1;33m[  !!  ] %s \e[0m\n" "$@"; }
info() { printf "\e[1;34m[  ..  ] %s \e[0m\n" "$@"; }
ask() { printf "\e[1;35m[  ??  ] %s \e[0m " "$@"; }

dotfiles_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

log_file="${dotfiles_directory}/$(date +%Y%m%d%H%M%S).log"
exec > >(tee -a "$log_file") 2>&1

# ────────────────[ Paru Setup ]────────────────
sleep 2
clear
cat <<"EOF"
██████╗  █████╗ ██████╗ ██╗   ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗
██╔══██╗██╔══██╗██╔══██╗██║   ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██████╔╝███████║██████╔╝██║   ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██╔═══╝ ██╔══██║██╔══██╗██║   ██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
██║     ██║  ██║██║  ██║╚██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝
EOF

if ! command -v paru &>/dev/null; then
    while true; do
        read -r -n 1 -p "$(ask "Install Paru? (Required) [Y/n]")" input
        echo
        case "${input:-y}" in
        [Yy])
            git clone https://aur.archlinux.org/paru.git
            (cd paru && makepkg -si)
            rm -rf paru
            okay "Paru installed successfully."
            break
            ;;
        [Nn])
            fail "Paru is required for this setup. Exiting..."
            exit 1
            ;;
        *) echo "Please enter either [Y] or [N]." ;;
        esac
    done
else
    okay "Paru is already installed. Skipping..."
fi

# ────────────────[ Package Installation ]────────────────
sleep 2
clear
cat <<"EOF"
██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

declare -a packages=(
    awww adw-gtk-theme blueman breeze fastfetch ffmpegthumbnailer hyprlock
    imagemagick imv inter-font kitty libnotify ly mako matugen mpv nautilus
    niri noto-fonts-cjk noto-fonts-emoji papirus-icon-theme pavucontrol
    qt6-wayland qt6ct-kde rofi starship ttf-jetbrains-mono-nerd waybar
    wl-clipboard xdg-desktop-portal-gnome xdg-desktop-portal-gtk
    xwayland-satellite zed zenity zsh-autosuggestions zsh-syntax-highlighting
)

mapfile -t packages < <(pacman -T "${packages[@]}")
if ((${#packages[@]})); then
    info "Missing packages:"
    printf '%s\n' "${packages[@]}"

    while true; do
        read -r -n 1 -p "$(ask "Install missing packages? [Y/n]")" input
        echo
        case "${input:-y}" in
        [Yy])
            paru -S "${packages[@]}"
            okay "Packages installed."
            break
            ;;
        [Nn])
            warn "Skipped. Your system will not work correctly."
            break
            ;;
        *) echo "Please enter either [Y] or [N]." ;;
        esac
    done
else
    okay "No packages to install."
fi

# ────────────────[ Dotfile Installation ]────────────────
sleep 2
clear
cat <<"EOF"
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

declare -a dotfiles=(
    .config .local Pictures
)

while true; do
    read -r -n 1 -p "$(ask "Download extra wallpapers? [y/N]")" input
    echo
    case "${input:-n}" in
    [Yy])
        if [[ -d "$HOME/Pictures/wallpapers/.git" ]]; then
            git -C "$HOME/Pictures/wallpapers" pull
        else
            mkdir -p "$HOME/Pictures/wallpapers"
            git clone --depth 1 "https://github.com/seraphicfae/wallpapers.git" "$HOME/Pictures/wallpapers"
        fi
        break
        ;;
    [Nn])
        info "Skipping wallpaper download."
        break
        ;;
    *) echo "Please enter either [Y] or [N]." ;;
    esac
done

while true; do
    read -r -n 1 -p "$(ask "Copy dotfiles to your directories? [Y/n]")" input
    echo
    case "${input:-y}" in
    [Yy])
        for folder in "${dotfiles[@]}"; do
            source="$dotfiles_directory/$folder"
            destination="$HOME/$folder"
            if [ -d "$source" ]; then
                mkdir -p "$destination"
                info "Syncing $folder..."
                cp -rfu "$source/." "$destination/"
            else
                warn "Source folder $source does not exist, skipping."
            fi
        done

        info "Setting up GTK 4.0..."
        gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
        gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
        gsettings set org.gnome.desktop.interface font-name 'Inter 11'
        gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
        gsettings set org.gnome.desktop.interface cursor-size '24'
        gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
        ln -sf /usr/share/themes/adw-gtk3/gtk-4.0/libadwaita.css "$HOME/.config/gtk-4.0/"
        okay "GTK 4 set!"
        break
        ;;
    [Nn])
        warn "Skipping copying dotfiles. Your configuration will not work."
        break
        ;;
    *) echo "Please enter either [Y] or [N]." ;;
    esac
done

# ────────────────[ Services and Setup ]────────────────
sleep 2
clear
cat <<"EOF"
███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
EOF

declare -a services=(
    ly@tty2
)
declare -a user_services=(
    mako waybar awww-daemon
)

while true; do
    read -r -n 1 -p "$(ask "Start services and configure environment? [Y/n]")" input
    echo
    case "${input:-y}" in
    [Yy])
        for service in "${services[@]}"; do
            if ! systemctl cat "${service}.service" &>/dev/null; then
                warn "Unit file for ${service} not found. Is it installed?"
                continue
            fi
            if systemctl is-enabled --quiet "${service}.service" 2>/dev/null; then
                info "${service} is already enabled. Skipping..."
                continue
            fi
            info "Enabling system service: ${service}..."
            sudo systemctl enable "${service}.service" &>/dev/null &&
                okay "${service} enabled." ||
                warn "Failed to enable ${service}."
        done

        for service in "${user_services[@]}"; do
            if ! systemctl --user cat "${service}.service" &>/dev/null; then
                warn "Unit file for ${service} not found. Is it installed?"
                continue
            fi
            if systemctl --user show --property=Wants --value niri.service 2>/dev/null |
                grep -q "${service}"; then
                info "${service} is already linked to niri.service. Skipping..."
                continue
            fi
            info "Linking ${service} to niri.service..."
            systemctl --user add-wants niri.service "${service}.service" &>/dev/null &&
                okay "${service} linked." ||
                warn "Failed to link ${service}."
        done

        if command -v zsh &>/dev/null; then
            if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
                info "Setting Zsh as default shell..."
                chsh -s /usr/bin/zsh "$USER"
                okay "Zsh set."
            else
                info "Zsh is already default."
            fi
            echo 'export ZDOTDIR="$HOME/.config/zsh"' >"$HOME/.zshenv"
        else
            warn "Zsh not found."
        fi

        okay "Services and environment configuration complete!"
        break
        ;;
    [Nn])
        warn "Configuration skipped."
        break
        ;;
    *) echo "Please enter either [Y] or [N]." ;;
    esac
done

# ────────────────[ Skip Me ]────────────────
sleep 2
clear
cat <<"EOF"
███████╗██╗  ██╗██╗██████╗     ███╗   ███╗███████╗
██╔════╝██║ ██╔╝██║██╔══██╗    ████╗ ████║██╔════╝
███████╗█████╔╝ ██║██████╔╝    ██╔████╔██║█████╗
╚════██║██╔═██╗ ██║██╔═══╝     ██║╚██╔╝██║██╔══╝
███████║██║  ██╗██║██║         ██║ ╚═╝ ██║███████╗
╚══════╝╚═╝  ╚═╝╚═╝╚═╝         ╚═╝     ╚═╝╚══════╝
EOF

declare -a packages=(
    apparmor gamescope gapless gnome-keyring gst-plugins-base
    gst-plugins-good gvfs-mtp helix kid3 obs-studio pacman-contrib
    plymouth pnpm qbittorrent reflector rsync satty snap-pac
)
declare -a appman_packages=(
    elyprismlauncher gapless helium ryujinx-canary steam vesktop
)
declare -a services=(
    auditd apparmor reflector.timer fstrim.timer paccache.timer
    snapper-cleanup.timer snapper-timeline.timer systemd-oomd
)
declare -a user_services=(
    gnome-keyring-daemon.service plasma-polkit-agent.service
)

mapfile -t packages < <(pacman -T "${packages[@]}" 2>/dev/null)
if ((${#packages[@]})); then
    info "The following optional packages are missing:"
    printf '%s\n' "${packages[@]}"
else
    info "All optional packages already installed."
fi

while true; do
    read -r -n 1 -p "$(warn "!DO NOT ACCEPT! These changes are for me. [y/N]")" input
    echo
    case "${input:-n}" in
    [Yy])
        info "Enabling Color output and ILoveCandy in /etc/pacman.conf..."
        grep -q '^Color' /etc/pacman.conf || sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
        grep -q '^ILoveCandy' /etc/pacman.conf || sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf

        info "Downloading and running the AppMan script.."
        curl -s -Lo ./AM-INSTALLER https://raw.githubusercontent.com/ivan-hc/AM/main/AM-INSTALLER && chmod a+x ./AM-INSTALLER && ./AM-INSTALLER && rm ./AM-INSTALLER
        appman -i "${appman_packages[@]}"
        appman nolibfuse vesktop

        info "Installing packages and starting services..."
        sudo pacman -S "${packages[@]}"
        sudo systemctl enable "${services[@]}"
        systemctl --user add-wants niri.service "${user_services[@]}"

        info "Setting up Plymouth boot splash, AppArmor, and AMD tweaks..."
        sudo mkdir -p /etc/cmdline.d
        grep -q 'plymouth' /etc/mkinitcpio.conf || sudo sed -i 's/udev autodetect/udev plymouth autodetect/' /etc/mkinitcpio.conf
        [ -f /etc/cmdline.d/plymouth.conf ] || echo 'quiet splash' | sudo tee /etc/cmdline.d/plymouth.conf
        [ -f /etc/cmdline.d/apparmor.conf ] || echo 'lsm=landlock,lockdown,yama,integrity,apparmor,bpf' | sudo tee /etc/cmdline.d/apparmor.conf
        [ -f /etc/cmdline.d/amd-pstate.conf ] || echo 'amd_pstate=active' | sudo tee /etc/cmdline.d/amd-pstate.conf
        sudo plymouth-set-default-theme -R bgrt

        info "Configuring reflector settings..."
        printf '%s\n' \
            '--save /etc/pacman.d/mirrorlist' \
            '--protocol https' \
            '--country US' \
            '--latest 10' \
            '--sort rate' |
            sudo tee /etc/xdg/reflector/reflector.conf >/dev/null

        info "Configuring DNS for Cloudflare.."
        sudo mkdir -p /etc/systemd/resolved.conf.d
        printf '%s\n' \
            '[Resolve]' \
            'DNS=1.1.1.1#cloudflare-dns.com 1.0.0.1#cloudflare-dns.com' \
            'FallbackDNS=9.9.9.9#dns.quad9.net' \
            'DNSSEC=yes' \
            'DNSOverTLS=yes' |
            sudo tee /etc/systemd/resolved.conf.d/dns.conf >/dev/null

        info "Setting up autostart apps..."
        mkdir -p "$HOME/.config/autostart"
        ln -sf "$HOME/.local/share/applications/steam-AM.desktop" "$HOME/.config/autostart"
        ln -sf "$HOME/.local/share/applications/helium-AM.desktop" "$HOME/.config/autostart"
        ln -sf "$HOME/.local/share/applications/vesktop-AM.desktop" "$HOME/.config/autostart"

        info "Copying Helix config for root..."
        sudo mkdir -p /root/.config
        sudo cp -r "$HOME/.config/helix" /root/.config
        sudo cp -r "$HOME/.config/qt6ct" /root/.config

        info "Updating XDG user dirs and applying GTK4 File Chooser settings..."
        xdg-user-dirs-update --force
        gsettings set org.gtk.gtk4.Settings.FileChooser show-hidden true
        gsettings set org.gtk.gtk4.Settings.FileChooser sort-directories-first true
        okay "Done!"
        break
        ;;
    [Nn])
        okay "Skipping optional tweaks and packages."
        break
        ;;
    *) echo "Please enter either [Y] or [N]." ;;
    esac
done

# ────────────────[ Reboot ]────────────────
sleep 2
clear
cat <<"EOF"
██████╗  ██████╗ ███╗   ██╗███████╗██╗
██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║
██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║
██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝
██████╔╝╚██████╔╝██║ ╚████║███████╗██╗
╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝
EOF

while true; do
    read -r -n 1 -p "$(ask "Would you like to reboot now? [Y/n]")" input
    echo
    case "${input:-y}" in
    [Yy])
        info "Rebooting system..."
        sudo systemctl reboot
        ;;
    [Nn])
        okay "Setup complete! It is recommend you reboot before using your new system."
        break
        ;;
    *) echo "Please enter either [Y] or [N]." ;;
    esac
done

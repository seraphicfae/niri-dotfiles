#!/usr/bin/env bash

# Creator : Mei Mei | https://github.com/seraphicfae/niri-dotfiles
# idiot proof install script. Feel free to adapt for your dotfiles

# ────────────────[ Themes and Functions ]────────────────
RESET="\e[0m"
BOLD="\e[1m"
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"

fail() { printf "${BOLD}${RED}[  NO  ] [ %s ]${RESET} %s\n" "$1"; }
okay() { printf "${BOLD}${GREEN}[  OK  ] [ %s ]${RESET} %s\n" "$1"; }
warn() { printf "${BOLD}${YELLOW}[  !!  ] [ %s ]${RESET} %s\n" "$1"; }
info() { printf "${BOLD}${BLUE}[  ..  ] [ %s ]${RESET} %s\n" "$1"; }
ask()  { printf "${BOLD}${MAGENTA}[  ??  ] [ %s ]${RESET} %s" "$1"; }

dotfiles_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_repository="https://github.com/seraphicfae/wallpapers.git"
wallpaper_directory="$HOME/Pictures/wallpapers"

# ────────────────[ Arch and SystemD Check ]────────────────
if [ -f /etc/arch-release ] || grep -qE "^(ID|ID_LIKE)=.*arch.*" /etc/os-release; then
    okay "Arch-based distribution detected."
else
    fail "This script is made for Arch based systems. Exiting..."
    exit 1
fi

if [ -d /run/systemd/system ]; then
    okay "Systemd is active."
else
    fail "This script requires systemd. Exiting..."
    exit 1
fi

# ────────────────[ Paru Setup ]────────────────
sleep 2
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  █████╗ ██████╗ ██╗   ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗
██╔══██╗██╔══██╗██╔══██╗██║   ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██████╔╝███████║██████╔╝██║   ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██╔═══╝ ██╔══██║██╔══██╗██║   ██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
██║     ██║  ██║██║  ██║╚██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝
EOF

if ! command -v paru &> /dev/null; then
    while true; do
        read -n 1 -r -p "$(ask "Paru is not installed. Install it now? [Y/n]")" input
        echo
        input="${input:-y}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            git clone https://aur.archlinux.org/paru.git
            cd paru && makepkg -si && cd ..
            rm -rf paru
            if ! command -v paru &> /dev/null; then
                warn "Installation failed. Something went horribly wrong."
            else
                okay "Paru installed successfully."
            fi
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            fail "Paru is required for this setup. Exiting..."
            exit 1
        else
            warn "Please enter either [Y] or [N]."
        fi
    done
else
    okay "Paru is already installed. Skipping..."
fi

# ────────────────[ Package Installation ]────────────────
sleep 2
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

declare -a required_packages=(
    awww-git
    blueman
    bluez-utils
    breeze
    cava
    fastfetch
    ffmpegthumbnailer
    gvfs-mtp
    hyprlock
    imv
    inter-font
    kitty
    ly
    mako
    matugen
    mission-center
    mpv
    nautilus
    network-manager-applet
    niri
    noto-fonts-cjk
    noto-fonts-emoji
    noto-fonts-extra
    papirus-icon-theme
    pavucontrol
    polkit-kde-agent
    qt5-wayland
    qt6-wayland
    qt6ct-kde
    rofi
    starship
    ttf-jetbrains-mono-nerd
    waybar
    wl-clip-persist
    wl-clipboard
    xdg-desktop-portal-gnome
    xdg-desktop-portal-gtk
    xwayland-satellite
    zed
    zsh
    zsh-autosuggestions
    zsh-syntax-highlighting
)

mapfile -t missing < <(pacman -T "${required_packages[@]}")

if (( ${#missing[@]} )); then
    warn "The following packages are missing:"
    echo "${missing[*]}" | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(ask "Install missing packages? [Y/n]")" input
        echo
        input="${input:-y}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            paru -S "${missing[@]}"
            okay "Packages installed."
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            warn "Skipped installing packages. Your system will not work correctly."
            break
        else
            warn "Please enter either [Y] or [N]."
        fi
    done
else
    okay "No packages to install."
fi

# ────────────────[ Dotfile Installation ]────────────────
sleep 2
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  ██████╗ ████████╗███████╗██╗██╗     ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔═══██╗╚══██╔══╝██╔════╝██║██║     ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██║  ██║██║   ██║   ██║   █████╗  ██║██║     █████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██║  ██║██║   ██║   ██║   ██╔══╝  ██║██║     ██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██████╔╝╚██████╔╝   ██║   ██║     ██║███████╗███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═════╝  ╚═════╝    ╚═╝   ╚═╝     ╚═╝╚══════╝╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

declare -a dotfile_paths=(
    ".config"
    ".local"
    "Pictures"
)

while true; do
    read -n 1 -r -p "$(ask "Download extra wallpapers? [y/N]")" input
    echo
    input="${input:-n}"

    if [[ "$input" =~ ^[Yy]$ ]]; then
        if [ -d "$wallpaper_directory/.git" ]; then
            info "Wallpapers already exist. Pulling updates..."
            git -C "$wallpaper_directory" pull
        else
            info "Downloading wallpapers into $wallpaper_directory..."
            mkdir -p "$wallpaper_directory"
            git clone --depth 1 "$wallpaper_repository" "$wallpaper_directory"
        fi
        okay "Wallpapers ready."
        break
    elif [[ "$input" =~ ^[Nn]$ ]]; then
        info "Skipping wallpaper download."
        break
    else
        warn "Please enter either [Y] or [N]."
    fi
done

while true; do
    read -n 1 -r -p "$(ask "Copy dotfiles to your directories? [Y/n]")" input
    echo
    input="${input:-y}"

    if [[ "$input" =~ ^[Yy]$ ]]; then
        for folder in "${dotfile_paths[@]}"; do
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

        info "Setting up GTK-4.0 theme symlink..."
        ln -sf ~/.local/share/themes/Orchis-Pink-Dark/gtk-4.0/* ~/.config/gtk-4.0/
        okay "Theme symlinked."
        break
    elif [[ "$input" =~ ^[Nn]$ ]]; then
        warn "Skipping dotfile copy. Your configuration will not be set."
        break
    else
        warn "Please enter either [Y] or [N]."
    fi
done

# ────────────────[ Services and Setup ]────────────────
sleep 2
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
EOF

declare -a services=(
    NetworkManager
    bluetooth
    ly@tty2.service
)

while true; do
    read -n 1 -r -p "$(ask "Start services and configure environment? [Y/n]")" input
    echo
    input="${input:-y}"

    if [[ "$input" =~ ^[Yy]$ ]]; then
        for service in "${services[@]}"; do
            if systemctl list-unit-files | grep -q "^${service}\.service"; then
                info "Enabling ${service}..."
                if sudo systemctl enable "$service" &>/dev/null; then
                    okay "${service} enabled."
                else
                    warn "Failed to enable ${service}."
                fi
            else
                warn "${service}.service not found. Is it installed?"
            fi
        done

        info "Setting wallpaper..."
        if ln -sf Pictures/wallpapers/wallpaper_01.png "$HOME/.local/state/current_wallpaper" 2>/dev/null; then
            okay "Wallpaper set."
        else
            warn "Wallpaper not found. Skipping."
        fi

        if command -v zsh &> /dev/null; then
            if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
                info "Setting Zsh as the default shell..."
                chsh -s /usr/bin/zsh "$(whoami)"
                okay "Default shell changed to Zsh."
            else
                info "Zsh is already the default shell."
            fi

            echo 'export ZDOTDIR="$HOME/.config/zsh"' > "$HOME/.zshenv"
        else
            warn "Zsh not found. Skipping shell configuration."
        fi

        okay "Services and environment configuration complete!"
        break

    elif [[ "$input" =~ ^[Nn]$ ]]; then
        warn "Skipped service and environment configuration. Your system may not work as intended."
        break
    else
        warn "Please enter either [Y] or [N]."
    fi
done

# ────────────────[ Completion ]────────────────
sleep 2
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
███████╗██╗  ██╗██╗██████╗     ███╗   ███╗███████╗
██╔════╝██║ ██╔╝██║██╔══██╗    ████╗ ████║██╔════╝
███████╗█████╔╝ ██║██████╔╝    ██╔████╔██║█████╗
╚════██║██╔═██╗ ██║██╔═══╝     ██║╚██╔╝██║██╔══╝
███████║██║  ██╗██║██║         ██║ ╚═╝ ██║███████╗
╚══════╝╚═╝  ╚═╝╚═╝╚═╝         ╚═╝     ╚═╝╚══════╝
EOF

declare -a optional_packages=(
    btrfs-assistant
    bun
    docker
    docker-compose
    elyprismlauncher-bin
    gamescope
    gapless
    helium-browser-bin
    keepassxc
    kid3
    neovim
    obs-studio
    opus-tools
    pacman-contrib
    plymouth
    python-pipx
    qbittorrent
    reflector
    rsync
    ryujinx-bin
    satty
    snap-pac
    steam
    vesktop-bin
)

declare -a optional_services=(
    reflector.timer
    fstrim.timer
    paccache.timer
    snapper-cleanup.timer
    snapper-timeline.timer
    docker.service
)

mapfile -t missing < <(pacman -T "${optional_packages[@]}" 2>/dev/null)

if (( ${#missing[@]} )); then
    info "The following optional packages are missing:"
    echo "${missing[*]}" | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(warn "!DO NOT ACCEPT! These changes are for me. Please know what you are doing [y/N]")" input
        echo
        input="${input:-n}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            info "Configuring /etc/pacman.conf..."
            sudo sed -i 's/^#Color/Color\nILoveCandy/' /etc/pacman.conf
            sudo sed -i '/\[multilib\]/,/Include/s/^#//' /etc/pacman.conf
            sudo pacman -Sy

            info "Installing packages and starting services.."
            paru -S --needed "${missing[@]}"
            sudo systemctl enable --now "${optional_services[@]}"

            info "Adding user to Docker group and making user directories..."
            sudo usermod -aG docker "$USER"
            xdg-user-dirs-update --force

            info "Configuring Plymouth splash screen..."
            sudo sed -i 's/udev autodetect/udev plymouth autodetect/g' /etc/mkinitcpio.conf
            sudo plymouth-set-default-theme -R bgrt

            okay "Done!"
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            okay "Skipping optional tweaks and packages."
            break
        else
            warn "Please enter either [Y] or [N]."
        fi
    done
else
    fail "Hi, Mei Mei!"
fi

# ────────────────[ Completion ]────────────────
sleep 2
clear
echo -e "${GREEN}${BOLD}"
cat << "EOF"
██████╗  ██████╗ ███╗   ██╗███████╗██╗
██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║
██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║
██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝
██████╔╝╚██████╔╝██║ ╚████║███████╗██╗
╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝
EOF

while true; do
    read -n 1 -r -p "$(ask "Would you like to reboot now? [Y/n]")" input
    echo
    input="${input:-y}"

    if [[ "$input" =~ ^[Yy]$ ]]; then
        info "Rebooting system..."
        sudo reboot
        break
    elif [[ "$input" =~ ^[Nn]$ ]]; then
        okay "Setup complete! I recommend you to reboot before using your new system."
        break
    else
        warn "Please enter either [Y] or [N]."
    fi
done

# Hey, you! Yeah, you! Good job on reading through this script. You never know what could be lurking! Your prize: The website I used for ascii art: https://patorjk.com/software/taag/#p=display&f=ANSI+Shadow&t=%3A3&x=none&v=4&h=4&w=80&we=false

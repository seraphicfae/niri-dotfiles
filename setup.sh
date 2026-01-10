#!/usr/bin/env bash

# Creator : Faye | https://github.com/seraphicfae/niri-dotfiles
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

timestamp() { date +%H:%M:%S; }
fail() { printf "[ %s ] ${BOLD}${RED}[ FAIL ]${RESET} %s\n" "$(timestamp)" "$1"; }
okay() { printf "[ %s ] ${BOLD}${GREEN}[  OK  ]${RESET} %s\n" "$(timestamp)" "$1"; }
warn() { printf "[ %s ] ${BOLD}${YELLOW}[  !!  ]${RESET} %s\n" "$(timestamp)" "$1"; }
info() { printf "[ %s ] ${BOLD}${BLUE}[ INFO ]${RESET} %s\n" "$(timestamp)" "$1"; }
ask()  { printf "[ %s ] ${BOLD}${MAGENTA}[  ??  ]${RESET} %s" "$(timestamp)" "$1"; }

dotfiles_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_repository="https://github.com/seraphicfae/wallpapers.git"
wallpaper_directory="$HOME/Pictures/wallpapers"

# ────────────────[ Arch and SystemD Check ]────────────────
if [ -f /etc/arch-release ] || grep -qE "^(ID|ID_LIKE)=.*arch.*" /etc/os-release; then
    okay "Arch-based distribution detected."
else
    fail "This is not an Arch-based distribution. This script is made for Arch-like systems. Exiting..."
    exit 1
fi

if [ -d /run/systemd/system ]; then
    okay "Systemd is running."
else
    fail "Systemd was not detected. This script requires systemd components. Exiting..."
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
        read -n 1 -r -p "$(ask "Paru is not installed. Install it now? [Y/n] ")" input
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
    blueman
    bluez-utils
    breeze
    catppuccin-sddm-theme-mocha
    cava
    fastfetch
    ffmpegthumbnailer
    gvfs-mtp
    hyprlock
    imagemagick
    imv
    kitty
    libnotify
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
    pantheon-polkit-agent
    papirus-icon-theme
    pavucontrol
    qt5-wayland
    qt6-wayland
    qt6ct-kde
    rofi
    rose-pine-cursor
    starship
    awww-git
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

declare -a optional_packages=(
    docker
    docker-compose
    elyprismlauncher-bin
    gamescope
    gapless
    gnome-boxes
    keepassxc
    kid3
    obs-studio
    python-pipx
    qbittorrent
    rsync
    ryujinx-bin
    satty
    helium-browser-bin
    vesktop-bin
    neovim
)

mapfile -t missing < <(pacman -T "${required_packages[@]}")

if (( ${#missing[@]} )); then
    warn "The following required packages are missing:"
    echo "${missing[*]}" | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(ask "Install required missing packages? [Y/n] ")" input
        echo
        input="${input:-y}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            paru -S "${missing[@]}"
            okay "Required packages installed."
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            warn "Skipped installation. Your system will not work correctly."
            break
        else
            warn "Please enter either [Y] or [N]."
        fi
    done
else
    okay "No required packages to install."
fi

mapfile -t missing < <(pacman -T "${optional_packages[@]}")

if (( ${#missing[@]} )); then
    info "The following optional packages are missing:"
    echo "${missing[*]}" | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(ask "You should skip installing these. [y/N] ")" input
        echo
        input="${input:-n}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            paru -S "${missing[@]}"
            okay "Optional packages installed."
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            info "Skipping optional packages."
            break
        else
            warn "Please enter either [Y] or [N]."
        fi
    done
else
    okay "No optional packages to install."
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
    read -n 1 -r -p "$(ask "Download extra wallpapers? [y/N] ")" input
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
    read -n 1 -r -p "$(ask "Copy dotfiles to your directories? [Y/n] ")" input
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
        warn "Skipping dotfile copy."
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
    sddm
    bluetooth
)

while true; do
    read -n 1 -r -p "$(ask "Start services and configure environment? [Y/n] ")" input
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

        if ! grep -q "Current=catppuccin-mocha-pink" /etc/sddm.conf 2>/dev/null; then
            info "Setting SDDM theme to Catppuccin Mocha (pink)..."
            echo -e "[Theme]\nCurrent=catppuccin-mocha-pink" | sudo tee /etc/sddm.conf > /dev/null
            okay "SDDM theme set."
        else
            info "SDDM theme already set. Skipping."
        fi

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
██████╗  ██████╗ ███╗   ██╗███████╗██╗
██╔══██╗██╔═══██╗████╗  ██║██╔════╝██║
██║  ██║██║   ██║██╔██╗ ██║█████╗  ██║
██║  ██║██║   ██║██║╚██╗██║██╔══╝  ╚═╝
██████╔╝╚██████╔╝██║ ╚████║███████╗██╗
╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝
EOF

while true; do
    read -n 1 -r -p "$(ask "Would you like to reboot now? [Y/n] ")" input
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

#!/usr/bin/env bash

# Creator : Faye | https://github.com/seraphicfae/niri-dotfiles
# idiot proof install script. Feel free to adapt for your dotfiles

# ────────────────[ Themes and Functions ]────────────────
GREEN="\e[32m"
YELLOW="\e[33m"
RED="\e[31m"
BLUE="\e[34m"
MAGENTA="\e[35m"
CYAN="\e[36m"
WHITE="\e[37m"
BOLD="\e[1m"
RESET="\e[0m"

okay()  { echo -e "${BOLD}${GREEN}[ OK ]${RESET} $1"; }
info()  { echo -e "${BOLD}${BLUE}[ .. ]${RESET} $1"; }
ask()   { echo -e "${BOLD}${MAGENTA}[ ? ]${RESET} $1"; }
warn()  { echo -e "${BOLD}${YELLOW}[ ! ]${RESET} $1"; }
fail()  { echo -e "${BOLD}${RED}[ FAIL ]${RESET} $1"; }
debug() { echo -e "${BOLD}${CYAN}[ DEBUG ]${RESET} $1"; }
note()  { echo -e "${BOLD}${WHITE}[ NOTE ]${RESET} $1"; }

dotfiles_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
wallpaper_repository="https://github.com/seraphicfae/wallpapers.git"
wallpaper_directory="$HOME/Pictures/wallpapers"

# ────────────────[ Arch and SystemD Check ]────────────────
if [ -f /etc/arch-release ] || grep -qi "arch" /etc/os-release; then
    okay "Arch-based distribution detected."
else
    fail "This is not an Arch-based distribution. Exiting..."
    exit 1
fi

if [ -d /run/systemd/system ]; then
    okay "SystemD is running."
else
    fail "SystemD is not found. This script requires SystemD. Exiting..."
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

required_packages=(
    blueman bluez-utils breeze catppuccin-sddm-theme-mocha cava fastfetch ffmpegthumbnailer gvfs-mtp hyprlock
    kitty mako matugen mission-center mpv nautilus network-manager-applet niri noto-fonts-cjk noto-fonts-emoji
    noto-fonts-extra pantheon-polkit-agent papirus-icon-theme pwvucontrol qt5-wayland qt6-wayland qt6ct-kde
    rofi rose-pine-cursor starship swww ttf-jetbrains-mono-nerd viewnior waybar wl-clip-persist wl-clipboard
    xdg-desktop-portal-gnome xdg-desktop-portal-gtk xwayland-satellite zed zsh imagemagick libnotify
)

optional_packages=(
    docker docker-compose elyprismlauncher-bin gapless gimp gnome-boxes gst-libav keepassxc kid3 obs-studio
    python-pipx qbittorrent rsync ryujinx-bin ungoogled-chromium-bin vesktop-bin neovim
)

required_missing_packages=($(for pkg in "${required_packages[@]}"; do
    pacman -Qq "$pkg" &>/dev/null || echo "$pkg"
done))

if (( ${#required_missing_packages[@]} > 0 )); then
    warn "The following required packages are missing:"
    printf "%s\n" "${required_missing_packages[@]}" | paste -sd " " - | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(ask "Install required missing packages? [Y/n] ")" input
        echo
        input="${input:-y}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            paru -S "${required_missing_packages[@]}"
            okay "Required packages installed."
            break
        elif [[ "$input" =~ ^[Nn]$ ]]; then
            warn "Skipped installation. Your system will not work correctly."
            break
        else
            warn "Please enter either [Y] or [N]."
        fi
    done
fi

optional_missing_packages=($(for pkg in "${optional_packages[@]}"; do
    pacman -Qq "$pkg" &>/dev/null || echo "$pkg"
done))

if (( ${#optional_missing_packages[@]} > 0 )); then
    note "The following optional packages are missing:"
    printf "%s\n" "${optional_missing_packages[@]}" | paste -sd " " - | fold -s -w 80

    while true; do
        read -n 1 -r -p "$(ask "You should skip installing these optional packages. [y/N] ")" input
        echo
        input="${input:-n}"

        if [[ "$input" =~ ^[Yy]$ ]]; then
            paru -S "${optional_missing_packages[@]}"
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
        info "Downloading wallpapers into $wallpaper_directory ..."
        mkdir -p "$wallpaper_directory"
        git clone --depth 1 "$wallpaper_repository" "$wallpaper_directory"
        okay "Wallpapers downloaded."
        break
    elif [[ "$input" =~ ^[Nn]$ ]]; then
        info "Skipping wallpaper download."
        break
    else
        warn "Please enter either [Y] or [N]."
    fi
done

while true; do
    read -n 1 -r -p "$(ask "Copy dotfiles to your config directory? [Y/n] ")" input
    echo
    input="${input:-y}"

    if [[ "$input" =~ ^[Yy]$ ]]; then
        for folder in "${dotfile_paths[@]}"; do
            source="$dotfiles_directory/$folder"
            destination="$HOME/$folder"

            if [ -d "$source" ]; then
                mkdir -p "$destination"
                info "Copying contents of $folder..."
                cp -rf "$source/"* "$destination/"
                okay "Successfully copied to $destination"
            else
                warn "Source folder $source does not exist, skipping."
            fi
        done
        break
    elif [[ "$input" =~ ^[Nn]$ ]]; then
        warn "Skipping dotfile copy. No files were copied."
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

services=(
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

        if ! grep -q "Current=catppuccin-mocha-mauve" /etc/sddm.conf 2>/dev/null; then
            info "Setting SDDM theme to Catppuccin Mocha (Mauve)..."
            echo -e "[Theme]\nCurrent=catppuccin-mocha-mauve" | sudo tee /etc/sddm.conf > /dev/null
            okay "SDDM theme set."
        else
            info "SDDM theme already set. Skipping."
        fi

        info "Setting wallpaper..."
        if cp -r "$HOME/.local/share/wallpapers/wallpaper_01.png" "$HOME/.local/state/current_wallpaper" 2>/dev/null; then
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
            mkdir -p "$HOME/.config/zsh"

            if [[ ! -d "$HOME/.config/zsh/antidote" ]]; then
                info "Installing Antidote plugin manager..."
                git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.config/zsh/antidote"
                okay "Antidote installed."
            fi
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

#!/usr/bin/env bash

# Creator : Mei Mei | https://github.com/seraphicfae/niri-dotfiles
# idiot proof install script. Feel free to adapt for your own dotfiles

# ────────────────[ Top Level Functions ]────────────────

fail() { printf "\e[1;31m[  NO  ] %s \e[0m\n" "$@"; }
okay() { printf "\e[1;32m[  OK  ] %s \e[0m\n" "$@"; }
warn() { printf "\e[1;33m[  !!  ] %s \e[0m\n" "$@"; }
info() { printf "\e[1;34m[  ..  ] %s \e[0m\n" "$@"; }
ask()  { printf "\e[1;35m[  ??  ] %s \e[0m " "$@"; }

dotfiles_directory="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ────────────────[ Paru Setup ]────────────────
sleep 2
clear
cat << "EOF"
██████╗  █████╗ ██████╗ ██╗   ██╗    ███████╗███████╗████████╗██╗   ██╗██████╗
██╔══██╗██╔══██╗██╔══██╗██║   ██║    ██╔════╝██╔════╝╚══██╔══╝██║   ██║██╔══██╗
██████╔╝███████║██████╔╝██║   ██║    ███████╗█████╗     ██║   ██║   ██║██████╔╝
██╔═══╝ ██╔══██║██╔══██╗██║   ██║    ╚════██║██╔══╝     ██║   ██║   ██║██╔═══╝
██║     ██║  ██║██║  ██║╚██████╔╝    ███████║███████╗   ██║   ╚██████╔╝██║
╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝     ╚══════╝╚══════╝   ╚═╝    ╚═════╝ ╚═╝
EOF

if ! command -v paru &>/dev/null; then
	while true; do
		read -n 1 -r -p "$(ask "Paru is not installed. Install it now? [Y/n]")" input
		echo
		input="${input:-y}"

		if [[ "$input" =~ ^[Yy]$ ]]; then
			git clone https://aur.archlinux.org/paru.git
			(cd paru && makepkg -si)
			rm -rf paru
			okay "Paru installed successfully."
			break
		elif [[ "$input" =~ ^[Nn]$ ]]; then
			fail "Paru is required for this setup. Exiting..."
			exit 1
		else
			echo "Please enter either [Y] or [N]."
		fi
	done
else
	okay "Paru is already installed. Skipping..."
fi

# ────────────────[ Package Installation ]────────────────
sleep 2
clear
cat << "EOF"
██████╗  █████╗  ██████╗██╗  ██╗ █████╗  ██████╗ ███████╗    ██╗███╗   ██╗███████╗████████╗ █████╗ ██╗     ██╗
██╔══██╗██╔══██╗██╔════╝██║ ██╔╝██╔══██╗██╔════╝ ██╔════╝    ██║████╗  ██║██╔════╝╚══██╔══╝██╔══██╗██║     ██║
██████╔╝███████║██║     █████╔╝ ███████║██║  ███╗█████╗      ██║██╔██╗ ██║███████╗   ██║   ███████║██║     ██║
██╔═══╝ ██╔══██║██║     ██╔═██╗ ██╔══██║██║   ██║██╔══╝      ██║██║╚██╗██║╚════██║   ██║   ██╔══██║██║     ██║
██║     ██║  ██║╚██████╗██║  ██╗██║  ██║╚██████╔╝███████╗    ██║██║ ╚████║███████║   ██║   ██║  ██║███████╗███████╗
╚═╝     ╚═╝  ╚═╝ ╚═════╝╚═╝  ╚═╝╚═╝  ╚═╝ ╚═════╝ ╚══════╝    ╚═╝╚═╝  ╚═══╝╚══════╝   ╚═╝   ╚═╝  ╚═╝╚══════╝╚══════╝
EOF

declare -a required_packages=(
	awww
	adw-gtk-theme
	blueman
	breeze
	cava
	fastfetch
	ffmpegthumbnailer
	gvfs-mtp
	hyprlock
	imagemagick
	imv
	inter-font
	kitty
	libnotify
	ly
	mako
	matugen
	mpv
	nautilus
	niri-wip-git
	noto-fonts-cjk
	noto-fonts-emoji
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

if ((${#missing[@]})); then
	echo -e "Missing packages: ${missing[*]}" | fold -s -w 80

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
			echo "Please enter either [Y] or [N]."
		fi
	done
else
	okay "No packages to install."
fi

# ────────────────[ Dotfile Installation ]────────────────
sleep 2
clear
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
		if [ -d "$HOME/Pictures/wallpapers/.git" ]; then
			git -C "$HOME/Pictures/wallpapers" pull
		else
			mkdir -p "$HOME/Pictures/wallpapers"
			git clone --depth 1 "https://github.com/seraphicfae/wallpapers.git" "$HOME/Pictures/wallpapers"
		fi
		break
	elif [[ "$input" =~ ^[Nn]$ ]]; then
		info "Skipping wallpaper download."
		break
	else
		echo "Please enter either [Y] or [N]."
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
		info "Setting up GTK 4.0..."
		gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'
		gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
		gsettings set org.gnome.desktop.interface font-name 'Inter 11'
		gsettings set org.gnome.desktop.interface cursor-theme 'breeze_cursors'
		gsettings set org.gnome.desktop.interface cursor-size '24'
		gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

		sudo ln -sf /usr/share/themes/adw-gtk3/gtk-4.0/libadwaita.css "$HOME/.config/gtk-4.0/"
		okay "GTK 4 set!"
		break
	elif [[ "$input" =~ ^[Nn]$ ]]; then
		warn "Skipping dotfile copy. Your configuration will not work."
		break
	else
		echo "Please enter either [Y] or [N]."
	fi
done

# ────────────────[ Services and Setup ]────────────────
sleep 2
clear
cat << "EOF"
███████╗███████╗██████╗ ██╗   ██╗██╗ ██████╗███████╗███████╗
██╔════╝██╔════╝██╔══██╗██║   ██║██║██╔════╝██╔════╝██╔════╝
███████╗█████╗  ██████╔╝██║   ██║██║██║     █████╗  ███████╗
╚════██║██╔══╝  ██╔══██╗╚██╗ ██╔╝██║██║     ██╔══╝  ╚════██║
███████║███████╗██║  ██║ ╚████╔╝ ██║╚██████╗███████╗███████║
╚══════╝╚══════╝╚═╝  ╚═╝  ╚═══╝  ╚═╝ ╚═════╝╚══════╝╚══════╝
EOF

declare -a system_services=(
    ly@tty2
    systemd-oom
)

declare -a user_services=(
	mako
	plasma-polkit-agent
	waybar
	awww-daemon
)

while true; do
	read -n 1 -r -p "$(ask "Start services and configure environment? [Y/n]")" input
	echo
	input="${input:-y}"

	if [[ "$input" =~ ^[Yy]$ ]]; then
		for service in "${system_services[@]}"; do
			if systemctl list-unit-files "$service.service" &>/dev/null; then
				info "Enabling system service: ${service}..."
				sudo systemctl enable "$service" &>/dev/null && okay "${service} enabled." || warn "Failed to enable ${service}."
			else
				warn "${service}.service not found."
			fi
		done

		for service in "${user_services[@]}"; do
			if systemctl --user list-unit-files "$service.service" &>/dev/null; then
				info "Linking ${service} to niri.service..."
				systemctl --user add-wants niri.service "$service.service" &>/dev/null && okay "${service} linked." || warn "Failed to link ${service}."
			else
				warn "User service ${service}.service not found."
			fi
		done

		if command -v zsh &>/dev/null; then
			if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
				info "Setting Zsh as default shell..."
				chsh -s /usr/bin/zsh "$USER" && okay "Zsh set."
			else
				info "Zsh is already default."
			fi
			echo 'export ZDOTDIR="$HOME/.config/zsh"' >"$HOME/.zshenv"
		else
			warn "Zsh not found."
		fi

		okay "Services and environment configuration complete!"
		break

	elif [[ "$input" =~ ^[Nn]$ ]]; then
		warn "Configuration skipped."
		break
	fi
done

# ────────────────[ Skip Me ]────────────────
sleep 2
clear
cat << "EOF"
███████╗██╗  ██╗██╗██████╗     ███╗   ███╗███████╗
██╔════╝██║ ██╔╝██║██╔══██╗    ████╗ ████║██╔════╝
███████╗█████╔╝ ██║██████╔╝    ██╔████╔██║█████╗
╚════██║██╔═██╗ ██║██╔═══╝     ██║╚██╔╝██║██╔══╝
███████║██║  ██╗██║██║         ██║ ╚═╝ ██║███████╗
╚══════╝╚═╝  ╚═╝╚═╝╚═╝         ╚═╝     ╚═╝╚══════╝
EOF

declare -a optional_packages=(
	apparmor
	eden-nightly-bin
	elyprismlauncher-bin
	fwupd
	gapless
	gst-plugins-base
	helium-browser-bin
	helix
	keepassxc
	kid3
	obs-studio
	pacman-contrib
	plymouth
	pnpm
	power-profiles-daemon
	qbittorrent
	reflector
	rsync
	satty
	snap-pac
	steam
	vesktop-bin
	vulkan-headers
)

declare -a optional_services=(
	auditd
	apparmor
	reflector
	fstrim
	paccache
	power-profiles-daemon
	snapper-cleanup
	snapper-timeline
)

mapfile -t missing < <(pacman -T "${optional_packages[@]}" 2>/dev/null)

if ((${#missing[@]})); then
	info "The following optional packages are missing:"
	echo "${missing[*]}" | fold -s -w 80

	while true; do
		read -n 1 -r -p "$(warn "!DO NOT ACCEPT! These changes are for me. Please know what you are doing [y/N]")" input
		echo
		input="${input:-n}"

		if [[ "$input" =~ ^[Yy]$ ]]; then
			info "Configuring /etc/pacman.conf..."
			sudo sed -i 's/^#Color/Color/' /etc/pacman.conf
			sudo sed -i '/^Color/a ILoveCandy' /etc/pacman.conf
			sudo pacman -Sy

			info "Installing packages and starting services..."
			paru -S --needed "${missing[@]}"
			sudo systemctl enable --now "${optional_services[@]}"

			info "Configuring Plymouth splash screen and AppArmor..."
			sudo sed -i 's/udev autodetect/udev plymouth autodetect/g' /etc/mkinitcpio.conf
			sudo sed -i 's/ quiet//g; s/ splash//g; s/rw/rw quiet splash/' /etc/kernel/cmdline
			sudo sed -i 's/$/ lsm=landlock,lockdown,yama,integrity,apparmor,bpf/' /etc/kernel/cmdline
			sudo plymouth-set-default-theme -R bgrt

			info "Finalizing some things..."
			sudo sed -i 's/--latest 5/--latest 10/' /etc/xdg/reflector/reflector.conf
			sudo sed -i 's/# --country France,Germany/--country US/' /etc/xdg/reflector/reflector.conf
			sudo mkdir -p /root/.config/helix
			sudo ln -sf "$HOME/.config/helix/config.toml" /root/.config/helix/config.toml
			powerprofilesctl set performance
			xdg-user-dirs-update --force
			okay "Done!"
			break
		elif [[ "$input" =~ ^[Nn]$ ]]; then
			okay "Skipping optional tweaks and packages."
			break
		else
			echo "Please enter either [Y] or [N]."
		fi
	done
else
	echo "Hi, Mei Mei!"
fi

# ────────────────[ Reboot ]────────────────
sleep 2
clear
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
		echo "Please enter either [Y] or [N]."
	fi
done

# Hey, you! Yeah, you! Good job on reading through this script. You never know what could be lurking! Your prize: The website I used for ascii art: https://patorjk.com/software/taag/#p=display&f=ANSI+Shadow&t=%3A3&x=none&v=4&h=4&w=80&we=false

#!/usr/bin/env bash

# ────────────────[ Top Level Functions ]────────────────

fail() { printf "\e[1;31m[  NO  ] %s \e[0m\n" "$@"; }
okay() { printf "\e[1;32m[  OK  ] %s \e[0m\n" "$@"; }
warn() { printf "\e[1;33m[  !!  ] %s \e[0m\n" "$@"; }

PASS=0
FAIL=0
WARN=0

pass() {
	okay "$1"
	((PASS++))
}
flunk() {
	fail "$1"
	((FAIL++))
}
caution() {
	warn "$1"
	((WARN++))
}

# ────────────────[ Paru ]────────────────

check_paru() {
	echo
	echo "━━━━━━━━━━━━━━━━━━[ Paru ]━━━━━━━━━━━━━━━━━━"

	if command -v paru &>/dev/null; then
		pass "paru is installed ($(paru --version 2>/dev/null | head -1))"
	else
		flunk "paru is not installed"
	fi
}

# ────────────────[ Required Packages ]────────────────

check_required_packages() {
	echo
	echo "━━━━━━━━━━━━━━━━━━[ Required Packages ]━━━━━━━━━━━━━━━━━━"

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

	mapfile -t missing < <(pacman -T "${required_packages[@]}" 2>/dev/null)

	local installed=$((${#required_packages[@]} - ${#missing[@]}))
	echo "Installed: $installed / ${#required_packages[@]}"

	if ((${#missing[@]} == 0)); then
		pass "All required packages are installed"
	else
		for package in "${missing[@]}"; do
			flunk "Missing required package: $package"
		done
	fi
}

# ────────────────[ Dotfiles ]────────────────

check_directory() {
	local path="$1"
	if [ -d "$HOME/$path" ]; then
		pass "Directory exists: ~/$path"
	else
		flunk "Directory missing: ~/$path"
	fi
}

check_file() {
	local path="$1"
	if [ -f "$HOME/$path" ]; then
		pass "File exists: ~/$path"
	else
		flunk "File missing: ~/$path"
	fi
}

check_dotfiles() {
	echo
	echo "━━━━━━━━━━━━━━━━━━[ Dotfiles → .config ]━━━━━━━━━━━━━━━━━━"

	for directory in cava fastfetch fontconfig gtk-3.0 gtk-4.0 helix hypr kitty mako matugen mpv niri qt6ct rofi systemd waybar zed zsh; do
		check_directory ".config/$directory"
	done

	check_file ".config/mimeapps.list"
	check_file ".config/starship.toml"

	echo
	echo "━━━━━━━━━━━━━━━━━━[ Dotfiles → .local ]━━━━━━━━━━━━━━━━━━"

	for script in launcher powermenu switch-wallpapers wallpaper-selector; do
		check_file ".local/bin/$script"
	done

	check_directory ".local/share/applications"
	check_directory ".local/share/icons"
	check_directory ".local/share/sounds"
	check_directory ".local/share/zed/extensions"

	echo
	echo "━━━━━━━━━━━━━━━━━━[ Dotfiles → Pictures ]━━━━━━━━━━━━━━━━━━"

	if [ -d "$HOME/Pictures/wallpapers" ]; then
		local count
		count=$(find "$HOME/Pictures/wallpapers" -maxdepth 1 -type f | wc -l)
		pass "Wallpapers directory exists ($count wallpapers)"
	else
		caution "Wallpapers directory not found at ~/Pictures/wallpapers"
	fi

	echo
	echo "━━━━━━━━━━━━━━━━━━[ Dotfiles → GTK Settings ]━━━━━━━━━━━━━━━━━━"

	local gtk_theme icon_theme cursor_theme font
	gtk_theme=$(gsettings get org.gnome.desktop.interface gtk-theme 2>/dev/null)
	icon_theme=$(gsettings get org.gnome.desktop.interface icon-theme 2>/dev/null)
	cursor_theme=$(gsettings get org.gnome.desktop.interface cursor-theme 2>/dev/null)
	font=$(gsettings get org.gnome.desktop.interface font-name 2>/dev/null)

    [[ "$gtk_theme" == "'adw-gtk3-dark'" ]] && pass "GTK gtk-theme is adw-gtk3-dark" || flunk "GTK gtk-theme is not set to adw-gtk3-dark (got: $gtk_theme)"
	[[ "$icon_theme" == "'Papirus'" ]] && pass "GTK icon-theme is Papirus" || flunk "GTK icon-theme is not set to Papirus (got: $icon_theme)"
	[[ "$cursor_theme" == "'breeze_cursors'" ]] && pass "GTK cursor-theme is breeze_cursors" || flunk "GTK cursor-theme is not set to breeze_cursors (got: $cursor_theme)"
	[[ "$font" == "'Inter 11'" ]] && pass "GTK font is Inter 11" || flunk "GTK font is not set to Inter 11 (got: $font)"
}

# ────────────────[ Services and Environment ]────────────────

check_services() {
	echo
	echo "━━━━━━━━━━━━━━━━━━[ Services and Environment ]━━━━━━━━━━━━━━━━━━"

	declare -a system_services=(
		ly@tty2
	)

	declare -a user_services=(
		mako
		plasma-polkit-agent
		waybar
		awww-daemon
	)

	for service in "${system_services[@]}"; do
		if systemctl is-enabled "${service}.service" &>/dev/null; then
			pass "System service is enabled: $service"
		else
			flunk "System service is NOT enabled: $service"
		fi
		if systemctl is-active "${service}.service" &>/dev/null; then
			pass "System service is active: $service"
		else
			warn "System service is NOT active: $service"
		fi
	done

	for service in "${user_services[@]}"; do
		if systemctl --user is-enabled "${service}.service" &>/dev/null; then
			pass "User service is enabled: $service"
		else
			flunk "User service is NOT enabled: $service"
		fi

		if systemctl --user is-active "${service}.service" &>/dev/null; then
			pass "User service is active: $service"
		else
			warn "User service is NOT active: $service"
		fi
	done

	if command -v zsh &>/dev/null; then
		pass "zsh is installed ($(zsh --version 2>/dev/null | head -1))"
		if [[ "$SHELL" == "/usr/bin/zsh" ]]; then
			pass "Default shell is zsh"
		else
			flunk "Default shell is not zsh (current: $SHELL)"
		fi
	else
		flunk "zsh is not installed"
	fi

	if [ -f "$HOME/.zshenv" ] && grep -q 'ZDOTDIR' "$HOME/.zshenv"; then
		pass "~/.zshenv sets ZDOTDIR"
	else
		flunk "~/.zshenv is missing or does not set ZDOTDIR"
	fi
}

# ────────────────[ Summary ]────────────────

print_summary() {
	echo
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
	printf "\e[1;32m  PASS: %d\e[0m\n" "$PASS"
	printf "\e[1;33m  WARN: %d\e[0m\n" "$WARN"
	printf "\e[1;31m  FAIL: %d\e[0m\n" "$FAIL"
	echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

	if ((FAIL == 0 && WARN == 0)); then
		okay "Everything looks good! Your setup is complete."
	elif ((FAIL == 0)); then
		warn "Setup looks mostly good, but there are $WARN warning(s) to review."
	else
		fail "$FAIL check(s) failed. Review the output above and re-run the installer for any missing pieces."
	fi
	echo
}

# ────────────────[ Run ]────────────────

case "${1:-all}" in
paru) check_paru ;;
packages) check_required_packages ;;
dotfiles) check_dotfiles ;;
services) check_services ;;
all)
	check_paru
	check_required_packages
	check_dotfiles
	check_services
	;;
*)
	echo "Usage: $0 [paru|packages|dotfiles|services|all]"
	exit 1
	;;
esac

print_summary

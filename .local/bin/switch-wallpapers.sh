#!/usr/bin/env bash
# Creator : Faye | https://github.com/seraphicfae/niri-dotfiles

wallpaper_folder="$HOME/.local/share/wallpapers"
index_tracker="$HOME/.local/state/wallpaper_index"
active_wallpaper="$HOME/.local/state/current_wallpaper"

mkdir -p "$(dirname "$index_tracker")"

mapfile -t wallpaper_list < <(find "$wallpaper_folder" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \) | sort)
[ ${#wallpaper_list[@]} -gt 0 ] || exit 1

if [[ -r "$index_tracker" && $(<"$index_tracker") =~ ^[0-9]+$ ]]; then
    current_index=$(<"$index_tracker")
else
    current_index=0
fi

(( current_index >= ${#wallpaper_list[@]} )) && current_index=0
next_index=$(( (current_index + 1) % ${#wallpaper_list[@]} ))

styles=("grow" "outer" "wipe" "wave")
positions=("center" "top" "bottom" "left" "right" "top-left" "top-right" "bottom-left" "bottom-right")
wave_settings=("20,20" "30,15" "25,25" "40,10")

chosen_style="${styles[random % ${#styles[@]}]}"
chosen_position="${positions[random % ${#positions[@]}]}"
chosen_wave="${wave_settings[random % ${#wave_settings[@]}]}"
duration="1.5"
frames_per_second="60"
angle=$((random % 360))

cp "${wallpaper_list[$next_index]}" "$active_wallpaper"
matugen image "$active_wallpaper"
printf '%d' "$next_index" > "$index_tracker"

swww img "$active_wallpaper" \
    --transition-type "$chosen_style" \
    --transition-pos "$chosen_position" \
    --transition-wave "$chosen_wave" \
    --transition-duration "$duration" \
    --transition-fps "$frames_per_second" \
    --transition-angle "$angle"

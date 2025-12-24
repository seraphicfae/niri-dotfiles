#!/usr/bin/env bash
# Creator : Faye | https://github.com/seraphicfae/niri-dotfiles

wallpaper_folder="$HOME/.local/share/wallpapers"
index_tracker="$HOME/.local/state/wallpaper_index"
active_wallpaper="$HOME/.local/state/current_wallpaper"

mkdir -p "$HOME/.local/state"

mapfile -t wallpaper_list < <(find "$wallpaper_folder" -type f \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.gif' \) | sort)

selected_name=$(
  for path in "${wallpaper_list[@]}"; do
    name=$(basename "$path")
    printf '%s\x00icon\x1fthumbnail://%s\n' "$name" "$path"
  done | rofi -dmenu -p "Select Wallpaper" -theme "$HOME/.config/rofi/wallpaper-selector.rasi"
)

[[ -z "$selected_name" ]] && exit 0

for index in "${!wallpaper_list[@]}"; do
    if [[ "$(basename "${wallpaper_list[$index]}")" == "$selected_name" ]]; then
        selected_path="${wallpaper_list[$index]}"
        selected_index="$index"
        break
    fi
done

styles=("grow" "outer" "wipe" "wave")
positions=("center" "top" "bottom" "left" "right" "top-left" "top-right" "bottom-left" "bottom-right")
waves=("20,20" "30,15" "25,25" "40,10")

chosen_style="${styles[random % ${#styles[@]}]}"
chosen_position="${positions[random % ${#positions[@]}]}"
chosen_wave="${waves[random % ${#waves[@]}]}"
duration="1.5"
frames_per_second="60"
angle=$((random % 360))

if [ -n "$selected_path" ]; then
    cp "$selected_path" "$active_wallpaper"
    matugen image "$active_wallpaper"
    printf '%d' "$selected_index" > "$index_tracker"

    swww img "$active_wallpaper" \
        --transition-type "$chosen_style" \
        --transition-pos "$chosen_position" \
        --transition-wave "$chosen_wave" \
        --transition-duration "$duration" \
        --transition-fps "$frames_per_second" \
        --transition-angle "$angle"
fi

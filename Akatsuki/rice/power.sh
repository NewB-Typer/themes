#!/usr/bin/env bash

# Import Current Theme
RASI="/$HOME/.config/rice/power.rasi"
CNFR="/$HOME/.config/rice/confirm.rasi"

# Theme Elements
prompt="Powermenu"
# Options
	option_1=" Lock"
	option_2="󰍃 Logout"
	option_3="󱎫 Suspend"
	option_4="󰑓 Reboot"
	option_5="⏻ Shutdown"

	yes=' Yes'
	no=' No'


# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "$prompt" \
		-markup-rows \
		-theme ${RASI}
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$option_1\n$option_2\n$option_3\n$option_4\n$option_5" | rofi_cmd
}


# Confirmation CMD
confirm_cmd() {
	rofi -dmenu \
		-p 'Confirmation' \
		-mesg 'Are you Sure?' \
		-theme ${CNFR}
}

# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}


# Confirm and execute
confirm_run() {
    selected="$(confirm_exit)"
    if [[ "$selected" == "$yes" ]]; then
        dunstify -a "Powermenu" -i "$3" "$2"
        eval "$1"
    else
        exit
    fi
}


# Execute Command
run_cmd() {
	if [[ "$1" == '--opt1' ]]; then
		dunstify -a "Powermenu" -i "$HOME/.config/dunst/icons/padlock-unlock.png" "Screen Unlocked..."
		swaylock
	elif [[ "$1" == '--opt2' ]]; then
		confirm_run 'hyprctl dispatch exit' 'Logging out...' "$HOME/.config/dunst/icons/padlock-unlock.png"
	elif [[ "$1" == '--opt3' ]]; then
		confirm_run 'pulsemixer --mute && swaylock --suspend' 'Suspending...' "$HOME/.config/dunst/icons/padlock.png"
	elif [[ "$1" == '--opt4' ]]; then
		confirm_run 'systemctl reboot' 'Rebooting...' "$HOME/.config/dunst/icons/reboot.png"
	elif [[ "$1" == '--opt5' ]]; then
		confirm_run 'systemctl poweroff' 'Shutting down...' "$HOME/.config/dunst/icons/power-button.png"
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $option_1)
		run_cmd --opt1
        ;;
    $option_2)
		run_cmd --opt2
        ;;
    $option_3)
		run_cmd --opt3
        ;;
    $option_4)
		run_cmd --opt4
        ;;
    $option_5)
		run_cmd --opt5
        ;;
esac

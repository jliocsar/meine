#!/usr/bin/env bash

nodemon --exec "
echo 'Killing all dunst instances'
sudo killall dunst > /dev/null 2>&1
concurrently 'dunst -config ~/.config/dunst/dunstrc' \
'notify-send DevTest 123 --urgency low --expire-time 360000' \
'notify-send DevTest Some_long_body_message_in_here --expire-time 360000' \
'notify-send ErrorTest Some_error_happened --urgency critical -h int:value:12' \
'notify-send \"Test Title\" \"Test long body\" --expire-time 360000 -h int:value:12'
" -w ~/.config/dunst/dunstrc -e dunstrc

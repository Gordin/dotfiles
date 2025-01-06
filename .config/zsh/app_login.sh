#!/bin/bash

USER_JSON_PATH=~/.config/zsh/app_login.json
source ~/.config/zsh/work.env

login_for_uid_prod() {
  SERVER=us-central1-studi-base
  USER_ID=$1
  JSON=$(curl -sS --request GET --url "https://$SERVER.cloudfunctions.net/generateMagicTokenLink?api_key=${STUDIBASE_API_KEY_PROD}&uid=${USER_ID}" --header 'accept: application/json')
  echo "$JSON" | jq -r '.magicLink'
}

pb() {
  curl -u "${PUSHBULLET_TOKEN}:" https://api.pushbullet.com/v2/pushes -d type=note -d body="$1"
}

pb_login_prod() {
  curl -u "${PUSHBULLET_TOKEN}:" https://api.pushbullet.com/v2/pushes -d type=link -d url="$LINK"
}

adb_login_prod() {
  LINK=$(login_for_uid_prod "$1")
  adb shell am start -a android.intent.action.VIEW -d "${LINK}"
}

login_for_uid_staging() {
  SERVER=us-central1-studi-base-staging
  USER_ID=$1
  JSON=$(curl -sS --request GET --url "https://$SERVER.cloudfunctions.net/generateMagicTokenLink?api_key=$STUDIBASE_API_KEY_STAGING&uid=$USER_ID" --header 'accept: application/json')
  echo "$JSON" | jq -r '.magicLink'
}

pb_login_staging() {
  LINK=$(login_for_uid_staging "$1")
  curl -u "${PUSHBULLET_TOKEN}:" https://api.pushbullet.com/v2/pushes -d type=link -d url="${LINK}"
}

adb_login_staging() {
  LINK=$(login_for_uid_staging "$1")
  adb shell am start -a android.intent.action.VIEW -d "${LINK}"
}

login_for_uid_testing() {
  SERVER=us-central1-studi-base-testing
  USER_ID=$1
  JSON=$(curl -sS --request GET --url "https://$SERVER.cloudfunctions.net/generateMagicTokenLink?api_key=$STUDIBASE_API_KEY_TESTING&uid=$USER_ID" --header 'accept: application/json')
  echo "$JSON" | jq -r '.magicLink'
}

pb_login_testing() {
  LINK=$(login_for_uid_testing "$1")
  curl -u "${PUSHBULLET_TOKEN}:" https://api.pushbullet.com/v2/pushes -d type=link -d url="${LINK}"
}

login_staging() {
  LINK=$(login_for_uid_staging "$1")
  echo adb shell am start -a android.intent.action.VIEW -d "$LINK"
  adb shell am start -a android.intent.action.VIEW -d "$LINK"
}

schiggy() {
  LINK=$(login_for_uid_staging tsFQGuo0JUWrhZWJQ0uXDhSV02a2)
  adb shell am start -a android.intent.action.VIEW -d "${LINK}"
}

get_debug_data () {
  local AUTH="$STAGING_PW"
  if [[ "$3" != '' ]]; then
	  AUTH="$STAGING_AUTH"
  else
	  AUTH="$PROD_AUTH"
  fi
  local URL="http://us-central1-studi-base$3.cloudfunctions.net/debugBookings?$1=$2"
  curl -Ss --request GET -u "$AUTH" "$URL"
}

uid_from_debug_data () {
	# echo "$1" > /dev/tty
	echo "$1" | sed 's/[[:cntrl:]]//g' | jq -Rnr '[inputs] | join("\\n") | fromjson | .uid'
}

echo_useful_urls () {
  echo "Debug URL:      http://us-central1-studi-base$2.cloudfunctions.net/debugBookings?uid=$1"
  echo "Firestore URL:  https://console.firebase.google.com/u/0/project/studi-base$2/firestore/data/~2Fusers~2F$1"
}

get_uid() {
  input="$1"
  env_string="$2"

  if [[ "$input" == *"@"* ]]; then
    output=$(uid_from_debug_data "$(get_debug_data "email" "$input" "$env_string")")
  elif [[ "$input" == "tech.studitemps"* ]]; then
    output=$(uid_from_debug_data "$(get_debug_data "uri"   "$input" "$env_string")")
  elif [[ "$input" == *"-"* ]] && [ "${#input}" -eq 36 ]; then
    output=$(uid_from_debug_data "$(get_debug_data "uuid"  "$input" "$env_string")")
  elif [[ "$input" =~ ^[0-9]+$ ]]; then
    output=$(uid_from_debug_data "$(get_debug_data "pn"    "$input" "$env_string")")
  elif [ "${#input}" -eq 28 ]; then
    output=$input
  else
    echo "None of the conditions were met."
    return 1
  fi

  # echo OUTPUT: \"$output\"
  echo "$output"
  return 0
}

push_link () {
  LINK=$1
  echo "Magiclink:      $LINK"
  echo
  if adb get-state 1>/dev/null 2>&1
  then
    echo 'Connected Android device found, logging you in!'
    adb shell am start -a android.intent.action.VIEW -d "${LINK}" 1>/dev/null 2>&1
    echo 'User logged in on Device'
    return 0
  else
    echo 'No connected Android device found, using pushbullet'
    # echo curl -s -u "${PUSHBULLET_TOKEN}:" https://api.pushbullet.com/v2/pushes -d type=link -d url="${LINK}" >/dev/tty
    curl -s -u "${PUSHBULLET_TOKEN}:" https://api.pushbullet.com/v2/pushes -d type=link -d url="${LINK}" >/dev/null
    echo 'Magiclink pushed to pushbullet'
    return 0
  fi
}

app_user_names  () { jq -r '.users | .[] | .name' < $USER_JSON_PATH; }
app_user_logins () { jq -r '.users | .[] | .login' < $USER_JSON_PATH; }
app_user_table  () { jq -r '.users | .[] | .name + " " + .login' < $USER_JSON_PATH; }

app_login() {
    if ! hash fzf &>/dev/null; then
        echo; echo "error: fzf is required for selection menu."; echo
        return 1
    fi

	keys=($(app_user_names))
	values=($(app_user_logins))

    local selected_bookmark
    local bookmarks_table
    local i
    for ((i=0; i<=${#keys[@]}; i++)); do
        bookmarks_table+="${keys[$i]} ${values[$i]}\n"
    done

    if [[ "$1" != '' ]]; then
        selected_bookmark=""
        for ((i=0; i<=${#keys[@]}; i++)); do
            if [[ "${keys[$i]}" == "$1" ]]; then
                selected_bookmark="${values[$i]}"
                break
            fi
        done
        if [[ "$selected_bookmark" == '' ]]; then
            selected_entry=$(app_user_table | fzf -f "$1" -1 --tiebreak=begin,length | head -1)
            selected_user=$(echo "$selected_entry" | cut --delimiter=' ' --fields=1)
            selected_bookmark=$(echo "$selected_entry" | cut --delimiter=' ' --fields=2,3)
        fi
    else
        selected_entry=$(app_user_table | fzf --exact --height='20%')
        selected_user=$(echo "$selected_entry" | cut --delimiter=' ' --fields=1)
        selected_bookmark=$(echo "$selected_entry" | cut --delimiter=' ' --fields=2,3)
    fi

    if [[ "$selected_bookmark" != '' ]]; then
        # echo "Selected: X${selected_bookmark}X"
        echo "Logging in \"$selected_user\""
        LINK=$(eval "$selected_bookmark")
        push_link "$LINK"
    elif [[ "$1" != '' && "$2" != '' ]]; then
        if [[ "$2" != 'prod' ]]; then
            env_string="-staging"
            uid=$(get_uid "$1" "$env_string")
            echo -e "\\nUID:            $uid"
            link=$(login_for_uid_staging "$uid")
        else
            env_string=""
            uid=$(get_uid "$1" "$env_string")
            echo -e "\\nUID:            $uid"
            link=$(login_for_uid_prod "$uid")
        fi
        echo_useful_urls "$uid" "$env_string"
        push_link "$link"
    else
        echo; echo 'error: Could not find any user to log in.'; echo
        return 1
    fi
}

bindkey -v
# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}
# Make Backspace and other shortcuts behave normally
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line
# bindkey -s '^L' '^Aapp_login ^M'
bindkey -M viins -s ',a' '^Aapp_login ^M'

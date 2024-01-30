
scan_local_network() {
    nmap -v -sn $(ip route get 8.8.8.8 | head -1 | awk '{print $3}' | grep -ohe '.\+\.')0/24 | sed '/host down/d' | grep -e '\(Nmap\|Host\)'
}

set_git_vars() {
    echo $PWD
    GIT_SSH_COMMAND='ssh -i  ~/.ssh/gordin_rsa' git
}

search_and_replace() {
  if [[ "$1" == '' ]]; then
    return
  fi

  inside_git_repo="$(git rev-parse --is-inside-work-tree 2>/dev/null)"
  if [ "$inside_git_repo" ]; then
    search_cmd=(git grep)
  else
    search_cmd=(grep -R)
  fi

  if [[ "$2" == '' ]]; then
    ${search_cmd[@]} --color=auto -I "$1"
  elif [[ "$3" == '' ]]; then
    ${search_cmd[@]} -I "$1" | sed "s/$1/$2/g" | grep --color=auto "$2"
  elif [[ "$3" == '!' ]]; then
    ${search_cmd[@]} -Il "$1" | xargs sed -i "s/$1/$2/g"
  fi
}

function colors() {
  for i in {0..255}
  do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

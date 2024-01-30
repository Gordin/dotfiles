
if (cat /proc/version | grep -qi microsoft); then
  # WSL usally starts in your Windows home, so cd to linux home instead
  # By doing this instead of changing the start directory, you can easily
  # get to your Windows home after opening a terminal with `cd -`
  cd ~

  cd() {
    # Check if no arguments to make just typing cd<Enter> work
    # Also check if the first argument starts with a - and let cd handle it
    if [ $# -eq 0 ] || [[ $1 == -* ]]
    then
      builtin cd $@
      return
    fi
    # If path exists, just cd into it
    # (also, using $* and not $@ makes it so you don't have to escape spaces any more)
    if [[ -d "$*" ]]
    then
      builtin cd "$*"
      return
    else
      # Try converting from Windows to absolute Linux path and try again
      WSLP=$(wslpath -ua "$*")
      if [[ -d "$WSLP" ]]
      then
        builtin cd "$WSLP"
        return
      fi
    fi
    # If both options don't work, just let the builtin cd handle it
    builtin cd "$*"
  }

  # This creates symlinks for all .exe files in a folder inside WSL. This folder is in PATH,
  # so you can access the binaries with fast autocompletion.
  # (Having system32 in PATH massively slows down autocompletion)
  update_system32_binaries() {
    mkdir -p $HOME/.cache/system32bin
    find /mnt/c/Windows/system32/ -maxdepth 1 -executable -type f -name '*.exe' -exec ln -s {} $HOME/.cache/system32bin \;
  }

  # Initialize system23 executables on first run
  if [ ! -d "$HOME/.cache/system32bin" ]; then
    update_system32_binaries
  fi

  # If in WSL, remove all windows stuff from path, except Windows dir for explorer.exe
  # This Speeds up Tab-completion A LOT. without this pressing TAB takes ~8.5 seconds, with this
  # ~100ms. Change /mnt/\c\/ to something different if the Windows drive is mounted somewhere else...
  C_DRIVE='/mnt/c'
  export PATH=$(echo ${PATH} | \
    awk -v RS=: -v ORS=: "/${C_DRIVE//\//\\/}/ {next} {print}" | sed 's/:*$//')
  # Add C:\Windows back so you can do `explorer.exe .` to open an explorer at current directory
  export PATH="$PATH:$C_DRIVE/Windows/"
  # export PATH="$PATH:$C_DRIVE/Windows/system32"
  export PATH="$PATH:$HOME/.cache/system32bin"

  # Set ip address for X server
  # export DISPLAY="$(ipconfig.exe | grep IPv4 | cut -d: -f2 | tr -d ' ' | head -1 | sed 's/[^[:print:]]//g'):0"
  # export DISPLAY=$(ip route show default | head -1 | cut -d ' ' -f3):0
  export DISPLAY=$(ip route show default | awk 'NR==1 { print $3 }'):0
fi

# Disable ctrl+s (freeze terminal) and ctrl+q (unfreeze terminal)
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

export EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config
# Base16 Shell
BASE16_SHELL="$HOME/.config/base16-shell/"
[ -n "$PS1" ] && \
    [ -s "$BASE16_SHELL/profile_helper.sh" ] && \
        source "$BASE16_SHELL/profile_helper.sh"

base16_gruvbox-dark-medium

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Start configuration added by Zim install {{{
#
# User configuration sourced by interactive shells
#

# -----------------
# Zsh configuration
# -----------------


#
# Input/output
#

# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v
# Make Backspace and other shortcuts behave normally
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

# Prompt for spelling correction of commands.
#setopt CORRECT

# with spelling correction, assume dvorak kb
setopt dvorak

# Allow comments even in interactive shells
setopt interactivecomments

# Customize spelling correction prompt.
#SPROMPT='zsh: correct %F{red}%R%f to %F{green}%r%f [nyae]? '

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}


# --------------------
# Module configuration
# --------------------

#
# completion
#

# Set a custom path for the completion dump file.
# If none is provided, the default ${ZDOTDIR:-${HOME}}/.zcompdump is used.
#zstyle ':zim:completion' dumpfile "${ZDOTDIR:-${HOME}}/.zcompdump-${ZSH_VERSION}"

#
# git
#

# Set a custom prefix for the generated aliases. The default prefix is 'G'.
#zstyle ':zim:git' aliases-prefix 'g'

#
# input
#

# Append `../` to your input for each `.` you type after an initial `..`
zstyle ':zim:input' double-dot-expand yes

#
# termtitle
#

# Set a custom terminal title format using prompt expansion escape sequences.
# See http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html#Simple-Prompt-Escapes
# If none is provided, the default '%n@%m: %~' is used.
#zstyle ':zim:termtitle' format '%1~'

#
# zsh-autosuggestions
#

# Customize the style that the suggestions are shown with.
# See https://github.com/zsh-users/zsh-autosuggestions/blob/master/README.md#suggestion-highlight-style
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=10'
ZSH_AUTOSUGGEST_USE_ASYNC=1
# Execute suggestion with <leader><cr>
bindkey -M viins ',^M' autosuggest-execute
# Accept and put cursor after suggestion with <leader>l
bindkey -M viins ',l' autosuggest-accept

#
# zsh-syntax-highlighting
#

# Set what highlighters will be used.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters.md
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets)

# Customize the main highlighter styles.
# See https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/docs/highlighters/main.md#how-to-tweak-it
#typeset -A ZSH_HIGHLIGHT_STYLES
#ZSH_HIGHLIGHT_STYLES[comment]='fg=10'

# ------------------
# Initialize modules
# ------------------

if [[ ${ZIM_HOME}/init.zsh -ot ${ZDOTDIR:-${HOME}}/.zimrc ]]; then
  # Update static initialization script if it's outdated, before sourcing it
  source ${ZIM_HOME}/zimfw.zsh init -q
fi
source ${ZIM_HOME}/init.zsh

# ------------------------------
# Post-init module configuration
# ------------------------------

#
# zsh-history-substring-search
#

# Bind ^[[A/^[[B manually so up/down works both before and after zle-line-init
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down

# Bind up and down keys
zmodload -F zsh/terminfo +p:terminfo
if [[ -n ${terminfo[kcuu1]} && -n ${terminfo[kcud1]} ]]; then
  bindkey ${terminfo[kcuu1]} history-substring-search-up
  bindkey ${terminfo[kcud1]} history-substring-search-down
fi

bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down
# }}} End configuration added by Zim install

# Aliases
alias -g ¦='| grep'
alias f='find . -name'
# alias fd='find . -type d -name'
alias ff='find . -type f -name'
alias h='history'
alias cpd='cp -r'
alias scpd='scp -r'
alias rmd='rm -rf'
alias lS='l -Sr --group-directories-first'
alias :q=exit
alias vim='set_bg; nvim'
alias agv='set_bg; nvim $(ag --nobreak --nonumbers --noheading . | fzf | sed "s/^\([^:]*\).*$/\1/")'
alias rgv='set_bg; nvim $(rg -N --no-heading --color never . | fzf | sed "s/^\([^:]*\).*$/\1/")'

alias psa='ps aux | grep -v "grep --color=auto" | grep'
alias lsport='sudo lsof -Pan -i tcp -i udp'
alias icanhazip='curl icanhazip.com'
alias update_mirrorlist='reflector -a 24 -f 20 -l 10 | sudo tee /etc/pacman.d/mirrorlist'
alias mirrorlist_update='update_mirrorlist'
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

alias yvim="yadm enter nvim"
alias ggit="GIT_SSH_COMMAND='ssh -i  ~/.ssh/gordin_rsa' git -c user.name=Gordin -c user.email=9ordin@gmail.com $@"
alias wgit="GIT_SSH_COMMAND='ssh -i  ~/.ssh/id_work' git -c user.name=andreasguthstuditemps -c user.email=andreas.guth@studitemps.de $@"
if [ "`hostname`" = workelch ]; then
  alias yadm="GIT_SSH_COMMAND='ssh -i ~/.ssh/gordin_rsa' yadm $@"
# elif [ "`hostname`" = Elchtop ]; then
#   alias yadm="GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519' yadm $@"
else
  # nothing
fi
# alias ssh='if ssh-add -l 1>/dev/null; then; else ssh-add -t 600; fi; ssh'
export HOSTNAME=$(hostname)
if [ "`hostname`" = workelch ]; then
  SSH_KEYS="$HOME/.ssh/id_rsa $HOME/.ssh/gordin_rsa $HOME/.ssh/docker_key"
  keychain -q --nogui $(echo $SSH_KEYS)
  source "$HOME/.keychain/$HOSTNAME-sh"
else
  SSH_KEYS="$HOME/.ssh/id_ecdsa $HOME/.ssh/id_ed25519"
  keychain -q --nogui $(echo $SSH_KEYS)
  source "$HOME/.keychain/$HOSTNAME-sh"
fi

if [ -x "$(command -v exa)"  ]; then
  alias l='exa -l'
  alias la='exa -la'
fi

export PATH=/opt/flutter/bin:$PATH
export PATH=${HOME}/.gem/ruby/2.7.0/bin:$PATH
export PATH=${HOME}/.local/share/gem/ruby/3.0.0/bin:$PATH
# export PATH=${HOME}/.gem/ruby/3.0.0/bin:$PATH
export PATH=${HOME}/.local/bin:$PATH
export PATH=${HOME}/.config/bin:$PATH
export PATH="${HOME}/.pub-cache/bin:$PATH"


export PKG_CONFIG_PATH=/usr/lib/pkgconfig/:$PKG_CONFIG_PATH

if [ -d "$HOME/.cargo/bin" ]; then
  export PATH=$HOME/.cargo/bin:$PATH
fi

if [ -d "$HOME/.config/nvm" ]; then
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm
  export PATH="$NVM_DIR/versions/node/$(<$NVM_DIR/alias/default)/bin:$PATH" #"
  alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@ || true"
fi

if [ -x "$(command -v brew)" ]; then
  eval $(brew shellenv)
  export PATH="$HOME/.config/sbin:$PATH"
fi

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

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export FZF_DEFAULT_COMMAND='rg --files --hidden --follow --no-ignore-vcs'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
[ -f "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh ] && source "${XDG_CONFIG_HOME:-$HOME/.config}"/fzf/fzf.zsh

PLENV_DIR=${HOME}/.plenv
export PATH="$PLENV_DIR/bin:$PATH"
if [ -d "$PLENV_DIR" ]; then
  eval "$(plenv init - zsh)"
fi

export PATH="$HOME/perl5/bin/:$PATH"

# move all paths ending in 'sbin' to the back of PATH
# This is needed because pyenv fails to find the system python otherwise
for SB in $(echo "$PATH" | grep ':*/[^:]*sbin' -o)
do
  export PATH="${PATH/$SB}:${SB#:}"
done

PYENV_ROOT=$HOME/.config/pyenv
if [ -d "$PYENV_ROOT" ]; then
  export PYENV_ROOT
  export PATH="$PYENV_ROOT/bin:$PATH"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi


#
# History
#

HISTFILE="$HOME/.config/zsh/.zhistory"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

function colors() {
  for i in {0..255}
  do print -Pn "%K{$i}  %k%F{$i}${(l:3::0:)i}%f " ${${(M)$((i%6)):#3}:+$'\n'}
  done
}

##
# shell bookmarks with fzf
# Most of this is taken from here https://asciinema.org/a/161022
# I just added forced fuzzy matching when used with an argument and the keybind
#
# Usage:
# put your bookmarks in the bookmarks array, reload your shell and
# b<ENTER> to get interactive fuzzy search for your bookmarks
# b X<ENTER> to cd to the first thing that (fuzzy) matches X in your bookmarks
# <ctrl+b> is a shortcut to `b SOMETHING<ENTER>`
# You can type `X<ctrl+b>` and you will cd to the best (fuzzy) match of X in your bookmarks
# Also works when you already started typing `cd XXXX`, it only looks at the last argument
#
# Works very well with just 1 or 2 keys before pressing <ctrl+b>
#
function b() {
    # Bookmarks
    local -A bookmarks=(
        'd' "~/Downloads/"
        'i' "~/Pictures/"
        'work' "~/work/"
        'firebase' "~/work/studibase/app/functions"
        'club' "~/work/clubhouse"
        'app' "~/work/student-services-app"
        'domain-events' "~/work/domain-events"
        'nvim' "~/.config/nvim"
        'packer' "~/.local/share/nvim/site/pack/packer/start"
        'student-data-finder' "~/work/student-data-finder"
        'jobsearch' "~/work/jobmensa-jobsearch"
    )

    local selected_bookmark
    local bookmarks_table
    local key
    foreach key (${(k)bookmarks}) {
      bookmarks_table+="$key ${bookmarks[$key]}\n"
    }

    if [[ "$1" != '' ]] {
        selected_bookmark="${bookmarks[$1]}"
        if [[ "$selected_bookmark" == '' ]] {
          for i in $@; do :; done
          last_argument=$i
            selected_bookmark=$(
            printf "$bookmarks_table" \
                | fzf -f $last_argument -1 --tiebreak=begin,length\
                | cut --delimiter=' ' --fields=2\
                | head -1
            )
        }
    } else {
        if (! hash fzf &>/dev/null) {
            echo; echo "error: fzf is required for selection menu."; echo

            return 1
        } else {
            selected_bookmark=$(
                printf "$bookmarks_table" \
                    | fzf \
                        --exact \
                        --height='20%' \
                        --preview='eval ls --almost-all --classify --color=always --group-directories-first --literal $(echo {} | cut --delimiter=" " --fields=2 -) 2>/dev/null' \
                        --preview-window='right:50%' \
                    | cut --delimiter=' ' --fields=2
            )
        }
    }

    if [[ "$selected_bookmark" != '' ]] {
        eval cd "$selected_bookmark"
    } else {
        echo; echo 'error: Could not find any bookmark to jump in.'; echo
        return 1
    }
}
# Bind for when ^A is bound (default)
# bindkey -s '^B' '^Ab ^M'
bindkey -M viins -s ',b' '^Ab ^M'
# bindkey -M viins -s '\--rf' '^?^A^[OC^[OC -rf'
# Bind for when ^A is not bound (vi mode)
# bindkey -s '^B' '^[Ib ^M'
# bindkey -M viins -s ',b' '^[Ib ^M'
alias ho='autorandr ho'

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    alias nvim="set_bg; nvr -cc split --remote-wait +'set bufhidden=wipe'"
fi

if [ -n "$NVIM_LISTEN_ADDRESS" ]; then
    export VISUAL="nvr -cc split --remote-wait +'set bufhidden=wipe'"
    export EDITOR="nvr -cc split --remote-wait +'set bufhidden=wipe'"
else
    export VISUAL="set_bg; nvim -O"
    export EDITOR="set_bg; nvim -O"
fi

export COLORTERM=truecolor

# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# . /opt/asdf-vm/asdf.sh

export GITSUBREPODIR=~/.config/git-subrepo
source "${GITSUBREPODIR}/.rc"

# .zshrc
set_bg () {
  saved_stty="$(stty -g)"
  stty raw -echo min 0 time 1
  printf "\033]11;?\007"
  read -r BG
  export BG="$(echo $BG | cut -c6-24)" 
  stty "$saved_stty"
}

# Set $BG on start
# set_bg

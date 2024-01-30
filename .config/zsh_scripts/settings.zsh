
# Disable ctrl+s (freeze terminal) and ctrl+q (unfreeze terminal)
stty ixany
stty ixoff -ixon
stty stop undef
stty start undef

export EDITOR=vim
export XDG_CONFIG_HOME=$HOME/.config

export COLORTERM=truecolor

export GITSUBREPODIR=~/.config/git-subrepo
source "${GITSUBREPODIR}/.rc"

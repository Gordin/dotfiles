# Start configuration added by Zim install {{{
#
# User configuration sourced by all invocations of the shell
#

: ${ZDOTDIR=${HOME}/.config/zsh}

# Define Zim location
: ${ZIM_HOME=${ZDOTDIR:-${HOME}}/zim}
# }}} End configuration added by Zim install

if [[ -z "$XDG_CONFIG_HOME" ]]
then
  export XDG_CONFIG_HOME="$HOME/.config/"
fi

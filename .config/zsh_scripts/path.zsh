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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
export PATH="$HOME/.fvm_flutter/bin:$PATH"

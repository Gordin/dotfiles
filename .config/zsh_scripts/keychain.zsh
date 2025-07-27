export HOSTNAME=$(hostname)

if [ "`hostname`" = workelch ]; then
  SSH_KEYS="$HOME/.ssh/id_rsa $HOME/.ssh/gordin_rsa $HOME/.ssh/docker_key"
  keychain -q --nogui $(echo $SSH_KEYS)
  source "$HOME/.keychain/$HOSTNAME-sh"
elif [ "`hostname`" = elchpad ]; then
  SSH_KEYS="$HOME/.ssh/id_ed25519"
  keychain -q --nogui $(echo $SSH_KEYS)
  source "$HOME/.keychain/$HOSTNAME-sh"
else
  SSH_KEYS="$HOME/.ssh/id_ecdsa $HOME/.ssh/id_ed25519"
  keychain -q --nogui $(echo $SSH_KEYS)
  source "$HOME/.keychain/$HOSTNAME-sh"
fi

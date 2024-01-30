if [ "`hostname`" = workelch ]; then
  alias yadm="GIT_SSH_COMMAND='ssh -i ~/.ssh/gordin_rsa' yadm $@"
elif [ "`hostname`" = Elchdesk ]; then
  alias yadm="GIT_SSH_COMMAND='ssh -i ~/.ssh/id_ed25519' yadm $@"
else
  # nothing
fi
# alias ssh='if ssh-add -l 1>/dev/null; then; else ssh-add -t 600; fi; ssh'

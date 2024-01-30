# Aliases
alias lg='lazygit'
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
alias vim='nvim'
alias agv='nvim $(ag --nobreak --nonumbers --noheading . | fzf | sed "s/^\([^:]*\).*$/\1/")'
alias rgv='nvim $(rg -N --no-heading --color never . | fzf | sed "s/^\([^:]*\).*$/\1/")'

alias psa='ps aux | grep -v "grep --color=auto" | grep'
alias lsport='sudo lsof -Pan -i tcp -i udp'
alias icanhazip='curl icanhazip.com'
alias update_mirrorlist='reflector -a 24 -f 20 -l 10 | sudo tee /etc/pacman.d/mirrorlist'
alias mirrorlist_update='update_mirrorlist'

alias yreset="yadm enter git reset"
alias yvim="bash -c 'cd;yadm enter nvim'"
alias ggit="GIT_SSH_COMMAND='ssh -i  ~/.ssh/gordin_rsa' git -c user.name=Gordin -c user.email=9ordin@gmail.com $@"

if [ -x "$(command -v exa)"  ]; then
  alias l='exa -l'
  alias la='exa -la'
fi

alias ho='autorandr ho'

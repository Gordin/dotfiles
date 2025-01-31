zimfw() { source /home/aguth/.config/zsh/zim/zimfw.zsh "${@}" }
zmodule() { source /home/aguth/.config/zsh/zim/zimfw.zsh "${@}" }
fpath=(/home/aguth/.config/zsh/zim/modules/git/functions /home/aguth/.config/zsh/zim/modules/utility/functions ${fpath})
autoload -Uz -- git-alias-lookup git-branch-current git-branch-delete-interactive git-branch-remote-tracking git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw
source /home/aguth/.config/zsh/zim/modules/environment/init.zsh
source /home/aguth/.config/zsh/zim/modules/git/init.zsh
source /home/aguth/.config/zsh/zim/modules/input/init.zsh
source /home/aguth/.config/zsh/zim/modules/termtitle/init.zsh
source /home/aguth/.config/zsh/zim/modules/utility/init.zsh
source /home/aguth/.config/zsh/zim/modules/powerlevel10k/powerlevel10k.zsh-theme
source /home/aguth/.config/zsh/zim/modules/zsh-completions/zsh-completions.plugin.zsh
source /home/aguth/.config/zsh/zim/modules/completion/init.zsh
source /home/aguth/.config/zsh/zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/aguth/.config/zsh/zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/aguth/.config/zsh/zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh

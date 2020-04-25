zimfw() { source /home/gordin/.zim/zimfw.zsh "${@}" }
fpath=(/home/gordin/.zim/modules/git/functions /home/gordin/.zim/modules/utility/functions ${fpath})
autoload -Uz git-alias-lookup git-branch-current git-branch-delete-interactive git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw
source /home/gordin/.zim/modules/environment/init.zsh
source /home/gordin/.zim/modules/git/init.zsh
source /home/gordin/.zim/modules/input/init.zsh
source /home/gordin/.zim/modules/termtitle/init.zsh
source /home/gordin/.zim/modules/utility/init.zsh
source /home/gordin/.zim/modules/powerlevel10k/powerlevel10k.zsh-theme
source /home/gordin/.zim/modules/zsh-completions/zsh-completions.plugin.zsh
source /home/gordin/.zim/modules/completion/init.zsh
source /home/gordin/.zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
source /home/gordin/.zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /home/gordin/.zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh
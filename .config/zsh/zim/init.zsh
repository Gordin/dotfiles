zimfw() { source ${ZDOTDIR}/zim/zimfw.zsh "${@}" }
fpath=(${ZDOTDIR}/zim/modules/git/functions ${ZDOTDIR}/zim/modules/utility/functions ${fpath})
autoload -Uz git-alias-lookup git-branch-current git-branch-delete-interactive git-dir git-ignore-add git-root git-stash-clear-interactive git-stash-recover git-submodule-move git-submodule-remove mkcd mkpw
source ${ZDOTDIR}/zim/modules/environment/init.zsh
source ${ZDOTDIR}/zim/modules/git/init.zsh
source ${ZDOTDIR}/zim/modules/input/init.zsh
source ${ZDOTDIR}/zim/modules/termtitle/init.zsh
source ${ZDOTDIR}/zim/modules/utility/init.zsh
source ${ZDOTDIR}/zim/modules/powerlevel10k/powerlevel10k.zsh-theme
source ${ZDOTDIR}/zim/modules/zsh-completions/zsh-completions.plugin.zsh
source ${ZDOTDIR}/zim/modules/completion/init.zsh
source ${ZDOTDIR}/zim/modules/zsh-autosuggestions/zsh-autosuggestions.zsh
source ${ZDOTDIR}/zim/modules/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${ZDOTDIR}/zim/modules/zsh-history-substring-search/zsh-history-substring-search.zsh

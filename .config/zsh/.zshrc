. ~/.config/zsh_scripts/settings.zsh
. ~/.config/zsh_scripts/base16.zsh
. ~/.config/zsh_scripts/p10k-instant-prompt.zsh
. ~/.config/zsh_scripts/keybinds.zsh
. ~/.config/zsh_scripts/zim.zsh
. ~/.config/zsh_scripts/substring-search.zsh
. ~/.config/zsh_scripts/functions.zsh
. ~/.config/zsh_scripts/aliases.zsh
. ~/.config/zsh_scripts/git.zsh
. ~/.config/zsh_scripts/keychain.zsh
. ~/.config/zsh_scripts/path.zsh
. ~/.config/zsh_scripts/wsl.zsh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

. ~/.config/zsh_scripts/fzf.zsh
. ~/.config/zsh_scripts/history.zsh
. ~/.config/zsh_scripts/b.zsh


export WORK_SCRIPTS="$HOME/.config/zsh/work.sh"
if [[ -f "$WORK_SCRIPTS" ]]; then
  source "$WORK_SCRIPTS"
fi



# Set editor default keymap to emacs (`-e`) or vi (`-v`)
bindkey -v

# Remove path separator from WORDCHARS.
WORDCHARS=${WORDCHARS//[\/]}
# Make Backspace and other shortcuts behave normally
bindkey "^?" backward-delete-char
bindkey "^W" backward-kill-word
bindkey "^H" backward-delete-char      # Control-h also deletes the previous char
bindkey "^U" backward-kill-line
bindkey '^A' beginning-of-line
bindkey '^E' end-of-line

setopt dvorak

# Allow comments even in interactive shells
setopt interactivecomments

# Execute suggestion with <leader><cr>
bindkey -M viins ',^M' autosuggest-execute
# Accept and put cursor after suggestion with <leader>l
bindkey -M viins ',l' autosuggest-accept

##
# shell bookmarks with fzf
# Most of this is taken from here https://asciinema.org/a/161022
# I just added forced fuzzy matching when used with an argument and the keybind
#
# Usage:
# put your bookmarks in the bookmarks array, reload your shell and
# b<ENTER> to get interactive fuzzy search for your bookmarks
# b X<ENTER> to cd to the first thing that (fuzzy) matches X in your bookmarks
# <ctrl+b> is a shortcut to `b SOMETHING<ENTER>`
# You can type `X<ctrl+b>` and you will cd to the best (fuzzy) match of X in your bookmarks
# Also works when you already started typing `cd XXXX`, it only looks at the last argument
#
# Works very well with just 1 or 2 keys before pressing <ctrl+b>
#
function b() {
    # Bookmarks
    local -A bookmarks=(
        'd' "~/Downloads/"
        'i' "~/Pictures/"
        'work' "~/work/"
        'firebase' "~/work/studibase/app/functions"
        'club' "~/work/clubhouse"
        'app' "~/work/student-services-app"
        'domain-events' "~/work/domain-events"
        'certification' "~/work/certification"
        'nvim' "~/.config/nvim"
        'packer' "~/.local/share/nvim/site/pack/packer/start"
        'student-data-finder' "~/work/student-data-finder"
        'jobsearch' "~/work/jobmensa-jobsearch"
    )

    local selected_bookmark
    local bookmarks_table
    local key
    foreach key (${(k)bookmarks}) {
      bookmarks_table+="$key ${bookmarks[$key]}\n"
    }

    if [[ "$1" != '' ]] {
        selected_bookmark="${bookmarks[$1]}"
        if [[ "$selected_bookmark" == '' ]] {
          for i in $@; do :; done
          last_argument=$i
            selected_bookmark=$(
            printf "$bookmarks_table" \
                | fzf -f $last_argument -1 --tiebreak=begin,length\
                | cut --delimiter=' ' --fields=2\
                | head -1
            )
        }
    } else {
        if (! hash fzf &>/dev/null) {
            echo; echo "error: fzf is required for selection menu."; echo

            return 1
        } else {
            selected_bookmark=$(
                printf "$bookmarks_table" \
                    | fzf \
                        --exact \
                        --height='20%' \
                        --preview='eval ls --almost-all --classify --color=always --group-directories-first --literal $(echo {} | cut --delimiter=" " --fields=2 -) 2>/dev/null' \
                        --preview-window='right:50%' \
                    | cut --delimiter=' ' --fields=2
            )
        }
    }

    if [[ "$selected_bookmark" != '' ]] {
        eval cd "$selected_bookmark"
    } else {
        echo; echo 'error: Could not find any bookmark to jump in.'; echo
        return 1
    }
}
# Bind for when ^A is bound (default)
# bindkey -s '^B' '^Ab ^M'
bindkey -M viins -s ',b' '^Ab ^M'
# bindkey -M viins -s '\--rf' '^?^A^[OC^[OC -rf'
# Bind for when ^A is not bound (vi mode)
# bindkey -s '^B' '^[Ib ^M'
# bindkey -M viins -s ',b' '^[Ib ^M'

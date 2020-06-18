if &compatible
  set nocompatible
endif

" Load packager only when you need it
function! PackagerInit() abort
  packadd vim-packager
  call packager#init()
  call packager#add('kristijanhusak/vim-packager', { 'type': 'opt' })
  " call packager#add('junegunn/fzf', { 'do': './install --all && ln -s $(pwd) ~/.fzf'})
  call packager#add('junegunn/fzf.vim')
  call packager#add('morhetz/gruvbox')

  call packager#add('neoclide/coc.nvim', { 'do': function('InstallCoc') })
endfunction

function! InstallCoc(plugin) abort
  exe '!cd '.a:plugin.dir.' && yarn install'
  call coc#util#install()
  call coc#add_extension('coc-eslint', 'coc-tsserver', 'coc-pyls')
endfunction

command! PackagerInstall call PackagerInit() | call packager#install()
command! -bang PackagerUpdate call PackagerInit() | call packager#update({ 'force_hooks': '<bang>' })
command! PackagerClean call PackagerInit() | call packager#clean()
command! PackagerStatus call PackagerInit() | call packager#status()

"Load plugins only for specific filetype
"Note that this should not be done for plugins that handle their loading using ftplugin file.
"More info in :help pack-add
augroup packager_filetype
  autocmd!
  " autocmd FileType javascript packadd vim-js-file-import
  " autocmd FileType go packadd vim-go
augroup END

"Lazy load plugins with a mapping
" nnoremap <silent><Leader>ww :unmap <Leader>ww<BAR>packadd vimwiki<BAR>VimwikiIndex<CR>

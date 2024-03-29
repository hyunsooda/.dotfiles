" File structure
" Vundle plugins
" General settings
" File type specific settings
" Omnicomplete settings
" Plugin settings
" Keyboard shortcuts

" #### Vim Plugins ############################
set nocompatible  " it must be the first line to enable Vim features.

" Auto-install vim-plug.
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

" Colorscheme
Plug 'crusoexia/vim-monokai'
Plug 'junegunn/seoul256.vim'
Plug 'dracula/vim', { 'as': 'dracula' }

" Autocomplete with tab key
Plug 'ervandew/supertab'

" Snippet autocomplete
Plug 'MarcWeber/vim-addon-mw-utils' " dependency
Plug 'tomtom/tlib_vim' " dependency
Plug 'honza/vim-snippets' " snippet database

" Head-up display (HUD)
Plug 'bling/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'majutsushi/tagbar'

" Language specific
Plug 'davidhalter/jedi-vim' " Python autocomplete
Plug 'fisadev/vim-isort' " Python import sort
Plug 'agatan/vim-sort-include' " C/C++ #include sort
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'derekwyatt/vim-scala'
Plug 'vim-scripts/closetag.vim' " html/xml auto close
Plug 'gregsexton/MatchTag' " highlight matching tags
Plug 'junegunn/vim-easy-align' " Align assignment statements
Plug 'tmux-plugins/vim-tmux'
Plug 'nvie/vim-flake8'
Plug 'blukat29/vim-llvm-lite' " LLVM IR and TableGen
Plug 'kchmck/vim-coffee-script'
Plug 'fatih/vim-go'
Plug 'google/yapf', { 'rtp': 'plugins/vim', 'for': 'python' }
Plug 'Chiel92/vim-autoformat'
Plug 'sbdchd/neoformat'
Plug 'rust-lang/rust.vim'
Plug 'racer-rust/vim-racer'
Plug 'robbles/logstash.vim'
Plug 'fsharp/vim-fsharp', {
      \ 'for': 'fsharp',
      \ 'do':  'make fsautocomplete',
      \}
Plug 'tomlion/vim-solidity'
Plug 'jiangmiao/auto-pairs'
Plug 'scrooloose/syntastic' "Syntastic
Plug 'cespare/vim-toml'
Plug 'souffle-lang/souffle.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neovimhaskell/haskell-vim'
Plug 'tpope/vim-commentary'
Plug 'LnL7/vim-nix' " nix expression

call plug#end()

" #### General ###################################
set clipboard=unnamed " use OS clipboard
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

syntax on       " syntax highlight
set hlsearch    " highlight search result
set number      " line numbers
set nowrap      " don't wrap long sentences
set viminfo=""  " disable viminfo

set scrolloff=3   " Keep 3 lines above and below cursor.
set laststatus=2  " Always turn on status line
set backspace=indent,eol,start  " Make backspace work as other editors
set tags=~/.vim/tags,tag;    " Read local tags file
"set tags=~/.vim/tags,tag,~/.opam/sparrow-4.08.0+flambda/tags;    " Read local tags file

" #### File type specific ########################

" File type mappings
autocmd BufNewFile,BufRead Dockerfile set filetype=config
autocmd BufNewFile,BufRead *.phps set filetype=php
autocmd BufNewFile,BufRead *.cup set filetype=java
autocmd BufNewFile,BufRead *.flex set filetype=java
autocmd BufNewFile,BufRead *.json set filetype=javascript
autocmd BufNewFile,BufRead bashrc set filetype=sh
autocmd BufNewFile,BufRead gitconfig set filetype=gitconfig
autocmd BufNewFile,BufRead gitconfig.common set filetype=gitconfig
autocmd BufNewFile,BufRead vimrc set filetype=vim
autocmd BufNewFile,BufRead Vagrantfile set filetype=ruby
autocmd BufNewFile,BufRead *.md set filetype=markdown
autocmd BufNewFile,BufRead *.ts set filetype=javascript " TypeScript
autocmd BufNewFile,BufRead *.ejs set filetype=html " EJS template
autocmd BufNewFile,BufRead *.edl set filetype=cpp " Enclave EDL
autocmd BufNewFile,BufRead *.gyp set filetype=javascript " GYP build system
autocmd BufNewFile,BufRead *.ml set filetype=ocaml " ocamlformat
autocmd BufNewFile,BufRead Jenkinsfile setf groovy
autocmd BufNewFile,BufRead *.gop set ft=rust
autocmd BufNewFile,BufRead *.goir set ft=go

" dosini syntax apply to *.conf
au BufEnter,BufRead *.conf setf dosini

" Teach vim to syntax highlight Vagrantfile as ruby
"
" Install: $HOME/.vim/plugin/vagrant.vim
" Author: Brandon Philips <brandon@ifup.org>

augroup vagrant
  au!
  au BufRead,BufNewFile Vagrantfile set filetype=ruby
augroup END

" Tab setting exceptions
autocmd Filetype javascript setlocal expandtab ts=2 sw=2 sts=2
autocmd Filetype css setlocal expandtab ts=2 sw=2 sts=2
autocmd Filetype html setlocal expandtab ts=2 sw=2 sts=2
autocmd Filetype htmldjango setlocal expandtab ts=2 sw=2 sts=2
autocmd Filetype xml setlocal expandtab ts=2 sw=2 sts=2
autocmd Filetype yaml setlocal expandtab ts=2 sw=2 sts=2
autocmd Filetype go setlocal noexpandtab
autocmd Filetype haskell setlocal expandtab ts=2 sw=2 sts=2

" Override syntax highlighting
" Highlights arrow function (=>), underscore.js (lodash), jquery APIs.
" Also highlights member variables.
function! SetJsHi()
    hi link javaScriptMy Conditional
    match javaScriptMy /\(=>\)\|\(\(_\|\$\)\.\w\+\)/
    hi link javaScriptMemberVar Function
    2match javaScriptMemberVar /this\.\w\+/
endfunction
autocmd BufNewFile,BufRead *.js call SetJsHi()

" complete option
set completeopt=longest,menuone

" #### Plugins ###################################

" Remove trailing whitespaces
command! RemoveTrailingWhitespaces %s/\s\+$//

" Jedi-Vim - no documentation window during completion.
autocmd FileType python setlocal completeopt-=preview
let g:jedi#show_call_signatures = 0

" Vim-airline
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#branch#enabled = 1

" GitGutter
let g:gitgutter_sign_removed = "-"
let g:gitgutter_sign_removed_first_line = "^"
let g:gitgutter_map_keys = 0
let g:gitgutter_realtime = 0
let g:gitgutter_eager = 0
autocmd BufWritePost * GitGutter

" TagBar
let g:tagbar_map_closeallfolds = "_"
let g:tagbar_map_openfold = "="
let g:tagbar_autofocus = 1
let g:tagbar_iconchars = ['+', '-']
let g:tagbar_width = 50
let g:tagbar_sort = 0
let g:tagbar_foldlevel = 2

let g:flake8_show_in_gutter = 1

" vim-go
let g:go_fmt_autosave = 1
let g:go_fmt_command = "gopls"
let g:go_gopls_gofumpt=1

let g:formatter_yapf_style = 'pep8'

" ocamlmerlin
let g:opamshare = substitute(system('opam config var share'),'\n$','','''')
execute "set rtp+=" . g:opamshare . "/merlin/vim"


" Syntastic (Recommended default setting)
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_quiet_messages = {"!level":  "errors",}


" Rust
let g:rustfmt_autosave = 1

" vim-racer(Rust Auto-Complete-er)
set hidden
let g:racer_cmd = "$HOME/.cargo/bin/racer"
let g:racer_experimental_completer = 1
let g:racer_insert_paren = 1

" #### Coloring ##################################

if (&term == "screen-256color") || (&term =~ "term")
  set t_Co=256
  set bg=dark
  silent! colorscheme seoul256
  hi Normal ctermbg=none ctermfg=254
  hi Comment ctermfg=245
  hi LineNr ctermbg=none
  hi GitGutterAdd ctermbg=none
  hi GitGutterChange ctermbg=none
  hi GitGutterDelete ctermbg=none
  hi GitGutterChangeDelete ctermbg=none
else
  colorscheme default
endif

" Color 80th column
function! s:toggle_color_column()
    if &colorcolumn > 0
        set colorcolumn=
    else
        set colorcolumn=80
    endif
endfunction
command! -nargs=0 ColorColumnToggle  call s:toggle_color_column()

" Current line highlight
function! s:current_line_highlight()
    set cursorline!
    hi CursorLine term=bold cterm=bold guibg=Grey40
endfunction
command! -nargs=0 CurLineHighlight  call s:current_line_highlight()

" Trailing Whitespace
hi TrailingWhitespace ctermbg=red
match TrailingWhitespace /\s\+$/
command! RemoveTrailingWhitespace :%s/\s\+$//

" #### Keyboard shortcuts #########################

" <Ctrl-l> redraws the screen and removes any search highlights
nnoremap <silent> <C-l> :nohl<CR><C-l>

" Map common mistakes.
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Set set
" Prevent writing to a file named ';'.
cnoreabbrev w; w

" Move between splits
nnoremap <Tab> <C-w>w

" Quickly compile C/C++
autocmd FileType c,cpp nnoremap <buffer> <F5> :w<CR>:make %<CR>
autocmd FileType c,cpp inoremap <buffer> <F5> <Esc>:w<CR>:make %<CR>
autocmd FileType c
  \ if !filereadable('Makefile') && !filereadable('makefile') |
  \   setlocal makeprg=gcc\ -o\ %< |
  \ endif
autocmd FileType cpp
  \ if !filereadable('Makefile') && !filereadable('makefile') |
  \   setlocal makeprg=g++\ -o\ %< |
  \ endif

" Quickly run python
autocmd FileType python nnoremap <buffer> <F5> :w<CR>:!python %<CR>
autocmd FileType python inoremap <buffer> <F5> <Esc>:w<CR>:!python %<CR>

" TagBar plugin
nmap <F8> :TagbarToggle<CR>

" Toggle color columns
nmap <F9> :ColorColumnToggle<CR>

" set cursor line
nmap <F7> :CurLineHighlight<CR>

" Easy align
xmap ga <Plug>(EasyAlign)

" Toggle paste mode with Control-P
set pastetoggle=<C-p>

" Comment Macro
let @c="^i// \<ESC> \<Down>"   "@c
" fmt.Println Macro
let @f="fmt.Println( "         "fp

map <C-Y> :call yapf#YAPF()<cr>
imap <C-Y> <c-o>:call yapf#YAPF()<cr>


" @@@@@@@@@@@@@@@@@@@@@@@@@@@ OCaml @@@@@@@@@@@@@@@@@@@@@@@@@@@
" ## added by OPAM user-setup for vim / base ## 93ee63e278bdfc07d1139a748ed3fff2 ## you can edit, but keep this line
let s:opam_share_dir = system("opam config var share")
let s:opam_share_dir = substitute(s:opam_share_dir, '[\r\n]*$', '', '')

let s:opam_configuration = {}

function! OpamConfOcpIndent()
  execute "set rtp^=" . s:opam_share_dir . "/ocp-indent/vim"
endfunction
let s:opam_configuration['ocp-indent'] = function('OpamConfOcpIndent')

function! OpamConfOcpIndex()
  execute "set rtp+=" . s:opam_share_dir . "/ocp-index/vim"
endfunction
let s:opam_configuration['ocp-index'] = function('OpamConfOcpIndex')

function! OpamConfMerlin()
  let l:dir = s:opam_share_dir . "/merlin/vim"
  execute "set rtp+=" . l:dir
endfunction
let s:opam_configuration['merlin'] = function('OpamConfMerlin')

let s:opam_packages = ["ocp-indent", "ocp-index", "merlin"]
let s:opam_check_cmdline = ["opam list --installed --short --safe --color=never"] + s:opam_packages
let s:opam_available_tools = split(system(join(s:opam_check_cmdline)))
for tool in s:opam_packages
  " Respect package order (merlin should be after ocp-index)
  if count(s:opam_available_tools, tool) > 0
    call s:opam_configuration[tool]()
  endif
endfor
" ## end of OPAM user-setup addition for vim / base ## keep this line

let g:neoformat_ocaml_ocamlformat = {
            \ 'exe': 'ocamlformat',
            \ 'no_append': 1,
            \ 'stdin': 1,
            \ 'args': ['--disable-outside-detected-project', '--name', '"%:p"', '-']
            \ }
let g:neoformat_enabled_ocaml = ['ocamlformat']

" make ctags tailored to c++
noremap <F12> :!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>
inoremap <F12> <Esc>:!ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<cr>

" golang fold
set foldmethod=syntax
set nofoldenable
set foldlevel=2

" other languages fold
let javaScript_fold=1 "activate folding by JS syntax
let rust_fold=1

" LSP for Golang
augroup LspGo
  au!
  autocmd User lsp_setup call lsp#register_server({
      \ 'name': 'go-lang',
      \ 'cmd': {server_info->['gopls']},
      \ 'whitelist': ['go'],
      \ })
  autocmd FileType go setlocal omnifunc=lsp#complete
augroup END
map <F1> :LspDefinition<cr>
map <F2> :LspReferences<cr>

" Mappings for Rust
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

"Haskell indentation
let g:haskell_enable_quantification = 1   " to enable highlighting of `forall`
let g:haskell_enable_recursivedo = 1      " to enable highlighting of `mdo` and `rec`
let g:haskell_enable_arrowsyntax = 1      " to enable highlighting of `proc`
let g:haskell_enable_pattern_synonyms = 1 " to enable highlighting of `pattern`
let g:haskell_enable_typeroles = 1        " to enable highlighting of type roles
let g:haskell_enable_static_pointers = 1  " to enable highlighting of `static`
let g:haskell_backpack = 1                " to enable highlighting of backpack keywords
let g:haskell_indent_before_where = 2
let g:haskell_indent_after_bare_where = 2

"Haskell formatter
let g:neoformat_haskell_ormolu = { 'exe': 'ormolu', 'args': []  }
let g:neoformat_enabled_haskell = ['ormolu']

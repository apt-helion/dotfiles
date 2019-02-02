""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" nvimrc {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" We need these folders to exist
call system('mkdir -p ~/.vim/session/' )           " session files (shared with vim)
call system('mkdir -p ~/.config/nvim/backup/' )    " backups folder
call system('mkdir -p ~/.config/nvim/undo/' )      " undo folder
call system('mkdir -p ~/.config/nvim/swap/' )      " swap files
call system('mkdir -p ~/.config/nvim/autoload/' )  " autoload folder
call system('mkdir -p ~/.config/nvim/plugged/')    " plugin folder

" Figure out the system python for neovim - we assume that the neovim python
" server has been installed globally.
if exists("$VIRTUAL_ENV")
  let g:python3_host_prog=substitute(system("which -a python3 | head -n2 | tail -n1"), "\n", '', 'g')
  let g:python_host_prog=substitute(system("which -a python | head -n2 | tail -n1"), "\n", '', 'g')
else
  let g:python3_host_prog=substitute(system("which python3"), "\n", '', 'g')
  let g:python_host_prog=substitute(system("which python3"), "\n", '', 'g')
endif

" Install vim plug if not already
if empty(glob('~/.condig/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $DOTFILES/nvimrc
endif

" Add plugins here
call plug#begin('~/.config/nvim/plugged')

" tools
Plug 'scrooloose/nerdtree'
Plug 'jlanzarotta/bufexplorer'
Plug 'tpope/vim-fugitive'
Plug 'mbbill/undotree'
Plug 'majutsushi/tagbar'
Plug 'mhinz/vim-startify'
Plug 'metakirby5/codi.vim'
Plug 'moll/vim-node'
Plug 'w0rp/ale'
Plug 'vimwiki/vimwiki'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

" editing
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'thirtythreeforty/lessspace.vim'
Plug 'tomtom/tcomment_vim'
Plug 'easymotion/vim-easymotion'
Plug 'junegunn/vim-easy-align'
Plug 'rust-lang/rust.vim'
Plug 'junegunn/goyo.vim'
Plug 'tpope/vim-sleuth'
" code completion
Plug 'davidhalter/jedi-vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'zchee/deoplete-jedi'
Plug 'Shougo/neosnippet.vim'
Plug 'Shougo/neosnippet-snippets'

" display
Plug 'vim-airline/vim-airline'
Plug 'airblade/vim-gitgutter'
Plug 'scrooloose/syntastic'
Plug 'lervag/vimtex'
Plug 'Yggdroot/indentline'
Plug 'pangloss/vim-javascript'
Plug 'mxw/vim-jsx'
Plug 'pacha/vem-tabline'
Plug 'junegunn/limelight.vim'
Plug 'gabrielelana/vim-markdown'
" themes
Plug 'joshdick/onedark.vim'
Plug 'pbrisbin/vim-colors-off'

" Initialise plugin system
call plug#end()

" remove all existing autocmds
autocmd!

filetype off
syntax on
set nocompatible

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" BASIC EDITING {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","

" faster gitgutter
set updatetime=250
" remember more commands and search history
set history=1000
set tabstop=4
set shiftwidth=4
set autoindent
set incsearch
set showmatch
set expandtab
set nu
" Split predictably below
set splitbelow
" Split redictably right
set splitright
" make searches case-sensitve if they contain upper-case chars
set ignorecase smartcase
" highlight current line
set cursorline
set cmdheight=1
set switchbuf=useopen
set hidden
" make split char a solid line
set fillchars+=vert:\│
" set backups/undos
set backup
set undofile
set backupdir=$HOME/.config/nvim/backup/
set directory=$HOME/.config/nvim/swap/
set undodir=$HOME/.config/nvim/undo/
" allow backspacing over everything in insert mode
set backspace=indent,eol,start
" display incomplete commands
set showcmd
" make tab completion for files/buffers act like bash
set wildmode=longest,list
" folding
set fdm=marker
set foldlevel=99
" keep 3 lines below and above the cursor
set scrolloff=3
" if a file is changed outside vim reload it without asking
set autoread
" hlsearch
set hlsearch
" look in the current directory for 'tags', and work up the tree towards root until one is found.
set tags=./tags;/
" set conceal
set conceallevel=1
" set modelines
set modeline
set modelines=5

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrc
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  autocmd FileType python setlocal sw=4 ts=4 et
  autocmd FileType ruby setlocal sw=2 ts=2 et
  autocmd FileType javascript setlocal sw=2 ts=2 et
  autocmd FileType javascript.jsx setlocal ts=2 sts=2 sw=2

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()

  " If in particular window, just tab to main
  autocmd FileType nerdtree noremap <buffer> <Tab> <c-w>l
  autocmd FileType tagbar noremap <buffer> <Tab> <c-w>h

  " Automatic rename of tmux window
  if exists('$TMUX') && !exists('$NORENAME')
    au BufEnter * if empty(&buftype) | call system('tmux rename-window '.expand('%:t:S')) | endif
    au VimLeave * call system('tmux set-window automatic-rename on')
  endif
augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MISC KEY MAPS {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" tab traverse
nnoremap <silent>tt :tabnew<CR>
nnoremap == gt
nnoremap -- gT

nnoremap <leader>nt :NERDTreeToggle<CR>
nnoremap <leader>tt :TagbarToggle<CR>
" nerd tree + tagbar
nnoremap <leader><Tab> :NERDTreeToggle<CR>:TagbarToggle<CR>

" window traverse
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" buffer traverse
nnoremap <Tab>j :bnext<CR>
nnoremap <Tab>k :bprevious<CR>
" close current buffer and move to previous one
nnoremap <leader>bq :bp <BAR> bd #<CR>

" bufexplorer
nnoremap <silent> <Leader>bl :BufExplorerVerticalSplit<CR>
let g:bufExplorerDisableDefaultKeyMapping=1

" vem-tabline
nmap <Tab>h <Plug>vem_move_buffer_left-
nmap <Tab>l <Plug>vem_move_buffer_right-

" move 'correctly' on wrapped lines
nnoremap j gj
nnoremap k gk

" Movement in insert mode
inoremap <C-h> <C-o>h
inoremap <C-l> <C-o>a
inoremap <C-j> <C-o>j
inoremap <C-k> <C-o>k

" save files as sudo
cnoremap w!! w !sudo tee > /dev/null %

" quick quit all
cnoremap qq qall

" edit nvimrc
nnoremap <Leader>rc :e $DOTFILES/nvimrc<CR>

" load current file in firefox
nnoremap <Leader>ff :!firefox %<CR>
" run py script
noremap <Leader>py :!python %<CR>
" run rb script
noremap <Leader>rb :!ruby %<CR>
" run sh script
noremap <Leader>sh :!sh %<CR>

" undotree
nnoremap <silent> U :UndotreeToggle <BAR> :UndotreeFocus<CR>

" Enable folding/unfold with the spacebar
nnoremap <space> za
nnoremap <leader><space> zR

" no highlight
nnoremap // :noh<CR>

" Reference current file's path
cnoremap <expr> %% expand('%:h').'/'

" Keep selection after indent
vnoremap < <gv
vnoremap > >gv

" move lines and blocks
" normal mode
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
" visual mode (blocks)
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

" indent a line
nnoremap <silent> <C-h> <<
nnoremap <silent> <C-l> >>

" easyalign
xmap ga <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

" Fzf
nnoremap <leader>f :FZF<CR>
" Also use ctrl-p because I am wayyyyy too used to it.
nnoremap <C-p> :FZF<CR>

" Fugitive
nnoremap <Leader>g :Gstatus<CR>gg<c-n>
nnoremap <Leader>d :Gdiff<CR>

" show weather report
nnoremap <silent> <Leader>we :! curl -s wttr.in/Sydney \| sed -r "s/\x1B\[[0-9;]*[JKmsu]//g"<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COMMANDS {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! Pyrun execute "!python -i %"
command! Trim :%s/\s*$//g | nohlsearch | exe "normal! g'\""

" Change colorscheme
command! Mono :colorscheme off | hi Normal ctermbg=none
command! Colour :colorscheme onedark | hi Normal ctermbg=none

" chmod +x
command! EX
  \  if !empty(expand('%'))
  \|   write
  \|   call system('chmod +x '.expand('%'))
  \|   silent e
  \| else
  \|   echohl WarningMsg
  \|   echo 'Save the file first'
  \|   echohl None
  \| endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" FUNCTIONS {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Rename current file
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'), 'file')
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
nnoremap <leader>rn :call RenameFile()<cr>

" Append modeline after last line in buffer.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Use substitute() instead of printf() to handle '%%s' modeline in LaTeX
" files.
function! AppendModeline()
  let l:modeline = printf(" vim: set ts=%d sw=%d tw=%d fdm=%s %set :",
    \ &tabstop, &shiftwidth, &textwidth, &foldmethod, &expandtab ? '' : 'no')
  let l:modeline = substitute(&commentstring, "%s", l:modeline, "")
  call append(line("$"), l:modeline)
endfunction
nnoremap <silent> <Leader>ml :call AppendModeline()<CR>

" Change directory to the root of the Git repository
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:root()
  let root = systemlist('git rev-parse --show-toplevel')[0]
  if v:shell_error
    echo 'Not in git repo'
  else
    execute 'lcd' root
    echo 'Changed directory to: '.root
  endif
endfunction
command! Root call s:root()

" Folds
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
hi Folded term=bold cterm=NONE ctermfg=lightblue
function! NeatFoldText()
  let line = ' ' . substitute(getline(v:foldstart), '^\s*"\?\s*\|\s*"\?\s*{{' . '{\d*\s*', '', 'g') . ' '
  let lines_count = v:foldend - v:foldstart + 1
  let lines_count_text = '| ' . printf("%10s", lines_count . ' lines') . ' |'
  let foldchar = '·'
  let foldtextstart = strpart('+' . repeat(foldchar, v:foldlevel*2) . line, 0, (winwidth(0)*2)/3)
  let foldtextend = lines_count_text . repeat(foldchar, 8)
  let foldtextlength = strlen(substitute(foldtextstart . foldtextend, '.', 'x', 'g')) + &foldcolumn
  return foldtextstart . repeat(foldchar, winwidth(0)-foldtextlength) . foldtextend
endfunction
set foldtext=NeatFoldText()

" Help in new tabs
" ----------------------------------------------------------------------------
function! s:helptab()
  if &buftype == 'help'
    wincmd T
    nnoremap <buffer> q :q<cr>
  endif
endfunction
autocmd vimrc BufEnter *.txt call s:helptab()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" OTHER PLUGINS {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Startify config
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:startify_session_dir ='~/.vim/session' " share sessions with normal vim

let g:startify_list_order = [
  \ ['   My sessions:'],
  \ 'sessions',
  \ ['   My most recently used files in the current directory:'],
  \ 'dir',
  \ ['   My most recently used files'],
  \ 'files',
  \ ['   My bookmarks:'],
  \ 'bookmarks',
  \ ['   My commands:'],
  \ 'commands',
\ ]

" Close Cleanup
let g:startify_session_before_save = [
  \ 'echo "Cleaning up before saving.."',
  \ 'silent! NERDTreeClose',
  \ 'silent! TagbarClose',
\ ]

let g:startify_bookmarks = [
  \ { 'v': '~/dotfiles/vimrc' },
  \ { 'n': '~/dotfiles/nvimrc' },
  \ { 'z': '~/dotfiles/zshrc' },
  \ { 'h': '~/dotfiles/hyper.js' },
\ ]

" Deoplete/Neosnippets
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:neosnippet#snippets_directory = '~/dotfiles/neosnippet'
let g:deoplete#enable_at_startup = 1
let g:deoplete#auto_complete_start_length = 3
let g:neosnippet#enable_snipmate_compatibility = 1
let g:jedi#show_call_signatures = "2"

inoremap <expr><C-n>  deoplete#mappings#manual_complete()

augroup startup_deoplete
  autocmd!
  autocmd FileType markdown
    \ call deoplete#custom#buffer_option('auto_complete', v:false)
augroup END

imap <expr><TAB>
 \ pumvisible() ? "\<CR>" :
 \ neosnippet#expandable_or_jumpable() ?
 \    "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

smap <expr><TAB> neosnippet#expandable_or_jumpable() ?
 \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

" Expands or completes the selected snippet/item in the popup menu
imap <expr><silent><CR> pumvisible() ? deoplete#mappings#close_popup() .
  \ "\<Plug>(neosnippet_jump_or_expand)" : "\<CR>"

smap <silent><CR> <Plug>(neosnippet_jump_or_expand

" Nerdtree
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1
let NERDTreeStatusline = '(~˘▾˘)~'

" Limelight
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Color name (:help cterm-colors) or ANSI code
let g:limelight_conceal_ctermfg = 'gray'
let g:limelight_conceal_ctermfg = 240

" Color name (:help gui-colors) or RGB color
let g:limelight_conceal_guifg = 'DarkGray'
let g:limelight_conceal_guifg = '#777777'

let g:limelight_default_coefficient = 0.9

" Number of preceding/following paragraphs to include (default: 0)
let g:limelight_paragraph_span = 5

" Highlighting priority (default: 10)
"   Set it to -1 not to overrule hlsearch
let g:limelight_priority = -1

" Goyo
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:goyo_enter()
  let b:quitting = 0
  let b:quitting_bang = 0
  autocmd QuitPre <buffer> let b:quitting = 1
  cabbrev <buffer> q! let b:quitting_bang = 1 <bar> q!
endfunction

function! s:goyo_leave()
  hi Normal ctermbg=none
  " Quit Vim if this is the only remaining buffer
  if b:quitting && len(filter(range(1, bufnr('$')), 'buflisted(v:val)')) == 1
    if b:quitting_bang
      qa!
    else
      qa
    endif
  endif
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()

let g:goyo_width = "70%"
let g:goyo_height = "80%"

" Indent lines
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:indentLine_enabled = 1 " enabled by default
let g:indentLine_conceallevel=1
let g:indentLine_char = "┆" " requires utf-8 in file

" Ale
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:ale_sign_error = '●' " Less aggressive than the default '>>'
let g:ale_sign_warning = '.'
let g:ale_lint_on_enter = 0 " Less distracting when opening a new file
let g:airline#extensions#ale#enabled = 1 " enable with airline

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" COLOUR {{{1
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" colourscheme
colorscheme onedark

" airline
let g:airline_theme='onedark'
let g:airline_powerline_fonts=0

" Use terminal background
hi Normal ctermbg=none
highlight NonText ctermbg=none

" vim: set ts=4 sw=2 tw=78 fdm=marker et :

" Basics
set nocompatible
filetype off

" Settings
set number
set cursorline
set wildmenu
set showcmd
set hlsearch
set ignorecase
set wildignorecase
" set smartcase
set autoindent
set nostartofline
set confirm
set noswapfile
set undolevels=1000
set shiftwidth=2
syntax on
filetype indent on
filetype plugin indent on

" Disable typescript-vim indent
let g:typescript_indent_disable = 1

" Maps
imap jj <Esc>

" Vundle stuff
set rtp+=~/.vim/bundle/Vundle.vim

call vundle#begin()

" Plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'preservim/nerdtree'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'neoclide/coc.nvim'
Plugin 'leafgarland/typescript-vim'
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plugin 'enricobacis/vim-airline-clock'
Plugin 'felipec/notmuch-vim'
Plugin 'tpope/vim-fugitive'
Plugin 'frazrepo/vim-rainbow'
Plugin 'jiangmiao/auto-pairs'

call vundle#end()

filetype plugin indent on

let g:rainbow_active = 1
let g:airline_powerline_fonts = 1



" CoC Tab completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Open NERDTree automatically
function! StartUp()
    if 0 == argc()
        NERDTree
    end
endfunction

autocmd VimEnter * call StartUp()

" Close NERDTree if it is the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

" vim-airline-clock
let g:airline#extensions#clock#format = '%H:%M:%S'
let g:airline#extensions#clock#updatetime = 1000



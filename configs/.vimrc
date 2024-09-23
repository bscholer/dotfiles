" -------- Basics --------
set nocompatible
filetype off
set number
set cursorline
set wildmenu
set showcmd
set hlsearch
set ignorecase smartcase
set wildignorecase
set autoindent
set nostartofline
set confirm
set noswapfile
set undolevels=1000
set shiftwidth=2
set cmdheight=2
set incsearch
syntax on
filetype plugin indent on


" -------- Maps --------
imap jj <Esc>
let mapleader = " " " map leader to space
nmap <leader>o o<Esc>k
nmap <leader>O O<Esc>j
nnoremap <leader>s :ToggleWorkspace<CR>
nnoremap <leader>v <c-v>


" -------- Plugins --------
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
  Plugin 'VundleVim/Vundle.vim'
  Plugin 'preservim/nerdtree'
  Plugin 'xuyuanp/nerdtree-git-plugin'
  Plugin 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plugin 'vim-airline/vim-airline'
  Plugin 'vim-airline/vim-airline-themes'
  Plugin 'enricobacis/vim-airline-clock'
  Plugin 'neoclide/coc.nvim'
  Plugin 'leafgarland/typescript-vim'
  Plugin 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plugin 'felipec/notmuch-vim'
  Plugin 'tpope/vim-fugitive'
  Plugin 'frazrepo/vim-rainbow'
  Plugin 'jiangmiao/auto-pairs'
  Plugin 'ryanoasis/vim-devicons'
  Plugin 'posva/vim-vue'
call vundle#end()


" -------- Misc. Plugin config --------
let g:rainbow_active = 1            " Enable rainbows
let g:airline_powerline_fonts = 1   " Enable powerline fonts
let g:typescript_indent_disable = 1 " Disable typescript-vim indent
let g:airline#extensions#clock#format = '%H:%M:%S'
let g:airline#extensions#clock#updatetime = 1000
let g:workspace_autocreate = 1
let g:workspace_autosave_always = 1
let g:NERDTreeFileExtensionHighlightFullName = 1
let g:NERDTreeExactMatchHighlightFullName = 1
let g:NERDTreePatternMatchHighlightFullName = 1


" -------- CoC config --------
" tab completion
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ CheckBackspace() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)


" -------- NERDTree config --------
" Start NERDTree automatically. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif
let NERDTreeShowHidden=1

" Close NERDTree if it is the last window open
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

"
" -------- Misc. --------
" make Vim jump to the last position when reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif


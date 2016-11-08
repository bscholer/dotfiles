set nocompatible
set hidden
set wildmenu
set showcmd
set hlsearch
set ignorecase
set smartcase
set autoindent
set nostartofline
set confirm
set visualbell
set relativenumber 

set clipboard=unnamedplus

set number
:highlight LineNr ctermfg=blue
:set cursorline

set shiftwidth=4
set tabstop=4

set undolevels=1000

filetype off
set omnifunc=syntaxcomplete#Complete

filetype plugin indent on

imap <M-h> <Left>
imap <M-l> <Right>
imap <M-k> <Up>
imap <M-j> <Down>
nmap J <C-w><C-h>
nmap K <C-w><C-l>

imap jj <Esc>
let mapleader=";;"

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'artur-shaik/vim-javacomplete2'
Plugin 'scrooloose/nerdcommenter'
Plugin 'Valloric/YouCompleteMe'
Plugin 'honza/vim-snippets'
Plugin 'ervandew/supertab'
Plugin 'SirVer/ultisnips'
Plugin 'yggdroot/indentline'
Plugin 'raimondi/delimitmate'
Plugin 'scrooloose/syntastic'
Plugin 'tmhedberg/simpylfold'
Plugin 'godlygeek/tabular'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'terryma/vim-expand-region'
Plugin 'tpope/vim-commentary'
Plugin 'vitalk/vim-simple-todo'
Plugin 'Chiel92/vim-autoformat'
Plugin 'plasticboy/vim-markdown'

let g:ctrlp_use_caching = 0
if executable('ag')
	    set grepprg=ag\ --nogroup\ --nocolor

		    let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
		else
			  let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . -co --exclude-standard', 'find %s -type f']
			    let g:ctrlp_prompt_mappings = {
				    \ 'AcceptSelection("e")': ['<space>', '<cr>', '<2-LeftMouse>'],
				    \ }
			endif

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" Indent after script/style tags
let g:html_indent_script1="inc"
let g:html_indent_style1="inc"

" Config for YouCompleteMe and C / C++
let g:ycm_global_ycm_extra_conf = '~/.ycm_extra_conf.py'
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
set laststatus=2
let g:airline_theme='bubblegum'
let g:airline_powerline_fonts = 1

let g:UltiSnipsExpandTrigger="<leader><space>"
let g:UltiSnipsJumpForwardTrigger="<leader>n"
let g:UltiSnipsJumpBackwardTrigger="<leader>p"

let g:ctrlp_working_path_mode = 'c'

let g:SimpylFold_docstring_preview = 1
set foldmethod=indent   
set foldnestmax=10
set nofoldenable
set foldlevel=2

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0 

function! SwapWords(dict, ...)
	    let words = keys(a:dict) + values(a:dict)
		    let words = map(words, 'escape(v:val, "|")')
			    if(a:0 == 1)
					        let delimiter = a:1
							    else
									        let delimiter = '/'
											    endif
												    let pattern = '\v(' . join(words, '|') . ')'
													    exe '%s' . delimiter . pattern . delimiter
														        \ . '\=' . string(Mirror(a:dict)) . '[S(0)]'
														        \ . delimiter . 'g'
													endfunction

autocmd FileType java setlocal omnifunc=javacomplete#Complete
set rtp+=/usr/local/lib/p

set t_Co=256

call vundle#end()
filetype plugin indent on 

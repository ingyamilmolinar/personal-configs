set number
set showmatch
set hlsearch
set incsearch
set ignorecase
set smartcase
set confirm
set cursorline
set tabstop=2
set shiftwidth=2
set noexpandtab
set encoding=UTF-8
syntax on
nnoremap / /\v
filetype on
filetype plugin indent on


" Go tags


" NERDTree
" Start NERDTree. If a file is specified, move the cursor to its window.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * NERDTree | if argc() > 0 || exists("s:std_in") | wincmd p | endif

" Exit Vim if NERDTree is the only window left.
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let g:NERDTreeHighlightCursorline = 1

" Specify a directory for plugins
" Make sure you use single quotes
call plug#begin('~/.vim/plugged')

Plug 'scrooloose/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'unkiwii/vim-nerdtree-sync'
Plug 'ryanoasis/vim-devicons'
Plug 'preservim/nerdcommenter'
Plug 'jiangmiao/auto-pairs'
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'tomasr/molokai'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries'  }
Plug 'yegappan/taglist'
Plug 'junegunn/fzf', { 'do': { -> fzf#install()  }  }
Plug 'junegunn/fzf.vim'
Plug 'ycm-core/YouCompleteMe'
Plug 'christoomey/vim-tmux-navigator'
Plug 'bling/vim-bufferline'
Plug 'neovimhaskell/haskell-vim'

call plug#end()

colorscheme molokai

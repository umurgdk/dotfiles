set nocompatible               " be iMproved
syn on
filetype off                   " required!

set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle
" required! 
Bundle 'gmarik/vundle'



filetype plugin indent on     " required!
"
" Brief help
" :BundleList          - list configured bundles
" :BundleInstall(!)    - install(update) bundles
" :BundleSearch(!) foo - search(or refresh cache first) for foo
" :BundleClean(!)      - confirm(or auto-approve) removal of unused bundles
"
" see :h vundle for more details or wiki for FAQ
" NOTE: comments after Bundle command are not allowed..

Bundle 'Enhanced-Javascript-syntax'
Bundle 'Auto-Pairs'
Bundle 'zencoding-vim'
Bundle 'MatchTag'
Bundle 'matchit.zip'
Bundle 'The-NERD-tree'
Bundle 'better-snipmate-snippet'
Bundle 'Command-T'
Bundle 'vim-slim'
Bundle 'vim-coffee-script'
Bundle 'coffee-check.vim'
Bundle 'The-NERD-Commenter'
Bundle 'scss-syntax'
Bundle 'vim-stylus'
Bundle 'Handlebars'
Bundle 'ack.vim'
Bundle 'nerdtree-ack'
Bundle 'fugitive.vim'
Bundle 'align-master'
Bundle 'rails.vim'

set ts=4
set sw=4
set nu

color molokai

set pastetoggle=<F2>
set mouse=a

nnoremap ; :
nnoremap <F1> :NERDTree <CR>
vnoremap <leader>p "_dP"

map <up> <nop>
map <down> <nop>
map <left> <nop>
map <right> <nop>

map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l

map <C-,> <C-y>,

au BufNewFile,BufRead *.slim set filetype=slim
au BufNewFile,BufRead *.coffee set filetype=coffee
au BufNewFile,BufRead *.styl set filetype=stylus
au BufNewFile,BufRead *.hbs set filetype=handlebars

autocmd Filetype coffee setlocal ts=2 sts=2 sw=2
autocmd Filetype coffee set expandtab

autocmd Filetype handlebars setlocal ts=2 sts=2 sw=2

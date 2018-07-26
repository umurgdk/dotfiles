call plug#begin('~/.vim/plugged')
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'scrooloose/nerdcommenter'
  Plug 'itchyny/lightline.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'junegunn/vim-easy-align'

  Plug 'rakr/vim-one'
  Plug 'junegunn/goyo.vim'
  Plug 'junegunn/limelight.vim'
  Plug 'jiangmiao/auto-pairs'

  Plug 'plasticboy/vim-markdown'
	Plug 'fatih/vim-go', { 'tag': '*', 'for': 'go' }

  Plug 'rust-lang/rust.vim'
      Plug 'prabirshrestha/asyncomplete.vim'
      Plug 'prabirshrestha/async.vim'
      Plug 'prabirshrestha/vim-lsp'
      Plug 'prabirshrestha/asyncomplete-lsp.vim'
    Plug 'vim-syntastic/syntastic'
    Plug 'maralla/vim-toml-enhance'
      Plug 'cespare/vim-toml'
call plug#end()

syntax on
filetype plugin indent on
set relativenumber
set sw=2
set ts=2
set expandtab
set incsearch
" set noshowmode "light line shows the mode

function! s:goyo_enter()
  hi! StatusLineNC gui=NONE guifg=NONE guibg=NONE term=underline ctermfg=0
endfunction

au! User GoyoEnter
au  User GoyoEnter nested call <SID>goyo_enter()

" set Vim-specific sequences for RGB colors
set t_8b=[48;2;%lu;%lu;%lum
set t_8f=[38;2;%lu;%lu;%lum

set termguicolors
if (empty($TMUX))
  if (has("nvim"))
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  if (has("termguicolors"))
    set termguicolors
  endif
endif

colorscheme one
set background=dark

let mapleader=","
nnoremap <leader>k :NERDTreeToggle<CR>
map ; :
map - :split<CR><C-W>j
map  :vsplit<CR><C-W>l

map <ESC>[72;5 5<C-W>>
map <ESC>[76;5 5<C-W><
map <ESC>[74;5 5<C-W>-
map <ESC>[75;5 5<C-W>+

map <C-h> <C-W>h
map <C-j> <C-W>j
map <C-k> <C-W>k
map <C-l> <C-W>l

map <leader>z :Goyo <bar> highlight StatusLineNC ctermfg=black<CR>

let g:easy_align_ignore_groups = ['String']
vmap <Enter> <Plug>(EasyAlign)
nmap ga <Plug>(EasyAlign)

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" Lightline
let g:lightline = {
      \ 'active': {
      \   'left': [ ['mode', 'paste'], ['gitbranch', 'readonly', 'filename', 'modified'] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ },
      \ }

" Markdown
au FileType markdown vmap <leader>t :EasyAlign*<Bar><CR>

" GoLang
let g:go_fmt_command = "goimports"
au FileType go map <leader>i :GoInfo<CR>
au FileType go map <leader>b :GoBuild<CR>

" Rust
let g:rustfmt_autosave = 1
let g:lsp_signs_enabled = 1         " enable signs
if executable('rls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'stable', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

au FileType rust map <leader>i :LspHover<CR>

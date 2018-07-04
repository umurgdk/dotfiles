call plug#begin('~/.vim/plugged')
	Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
  Plug 'scrooloose/nerdcommenter'

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
set number
set sw=2
set ts=2
set expandtab


let mapleader=","
nnoremap <leader>k :NERDTreeToggle<CR>
map ; :

let g:NERDTreeDirArrowExpandable="+"
let g:NERDTreeDirArrowCollapsible="~"

" GoLang
let g:go_fmt_command = "goimports"
au FileType go map <leader>i :GoInfo<CR>

" Rust
let g:rustfmt_autosave = 1
let g:lsp_signs_enabled = 1         " enable signs
if executable('rls')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'rls',
        \ 'cmd': {server_info->['rustup', 'run', 'nightly', 'rls']},
        \ 'whitelist': ['rust'],
        \ })
endif

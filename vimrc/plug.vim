" PLUGINS ---------------------------------------------------------------- {{{

call plug#begin('~/.vim/plugged')

  " NerdTree
  Plug 'preservim/nerdtree'

  " Treesitter
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " FZF
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'

call plug#end()

" }}}

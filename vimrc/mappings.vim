" MAPPINGS --------------------------------------------------------------- {{{

let mapleader = " "

" Press \\ to jump back to the last cursor position.
nnoremap <leader>\ ``

" Press \p to print the current file to the default printer from a Linux operating system.
" View available printers:   lpstat -v
" Set default printer:       lpoptions -d <printer_name>
" <silent> means do not display output.
nnoremap <silent> <leader>p :%w !lp<CR>

" Type jj to exit insert mode quickly.
inoremap jj <Esc>

" Pressing the letter o will open a new line below the current one.
" Exit insert mode after creating a new line above or below the current line.
nnoremap o o<esc>
nnoremap O O<esc>

" Center the cursor vertically when moving to the next word during a search.
nnoremap n nzz
nnoremap N Nzz

" Yank from cursor to the end of line.
nnoremap Y y$

" Map the F5 key to run a Python script inside Vim.
" I map F5 to a chain of commands here.
" :w saves the file.
" <CR> (carriage return) is like pressing the enter key.
" !clear runs the external clear screen command.
" !python3 % executes the current file with Python.
nnoremap <f5> :w <CR>:!clear <CR>:!python3 % <CR>

" You can split the window in Vim by typing :split or :vsplit.
" Navigate the split view easier by pressing CTRL+j, CTRL+k, CTRL+h, or CTRL+l.
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Resize split windows using arrow keys by pressing:
" CTRL+UP, CTRL+DOWN, CTRL+LEFT, or CTRL+RIGHT.
noremap <c-up> <c-w>+
noremap <c-down> <c-w>-
noremap <c-left> <c-w>>
noremap <c-right> <c-w><

" NERDTree specific mappings.
" Map the leader e key to toggle NERDTree open and close.
" nnoremap <silent> <leader>e :NERDTreeToggle<cr>

" Have nerdtree ignore certain files and directories.
" let NERDTreeIgnore=['\.git$', '\.jpg$', '\.mp4$', '\.ogg$', '\.iso$', '\.pdf$', '\.pyc$', '\.odt$', '\.png$', '\.gif$', '\.db$']

let s:nerdtree_focused = 0

nnoremap <leader>e :call ToggleNERDTreeFocus()<CR>

function! ToggleNERDTreeFocus()
  if s:nerdtree_focused
    " If NERDTree is focused, return focus to the previous window
    wincmd p
    let s:nerdtree_focused = 0
  else
    " Focus on NERDTree
    NERDTreeFocus
    let s:nerdtree_focused = 1
  endif
endfunction

" Fuzzy finder
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Ag<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fr :History<CR>
nnoremap <leader>ft :Tags<CR>

" Rebind Shift + Down Arrow to move one line down
nnoremap <S-Down> j

" Save the file
nnoremap <leader>w :w<cr>

" Quit with confirmation
nnoremap <leader>q :confirm q<cr>

" Create a new empty file
nnoremap <leader>n :enew<cr>

" Force quit (without saving)
nnoremap <C-q> :q!<cr>

" Vertical split
" nnoremap | :vsplit<cr>

" Horizontal split
nnoremap \ :split<cr>

" Save file (mapped to <leader>s in normal mode)
nnoremap <leader>s :w<cr>

" Select up (mapped to Shift + Up in visual mode)
vnoremap <S-Up> <Up>

" Select down (mapped to Shift + Down in visual mode)
vnoremap <S-Down> <Down>

" Select left (mapped to Shift + Left in visual mode)
vnoremap <S-Left> <Left>

" Select right (mapped to Shift + Right in visual mode)
vnoremap <S-Right> <Right>

" Unindent line in visual mode (Shift + Tab)
vnoremap <S-Tab> <gv

" Indent line in visual mode (Tab)
vnoremap <Tab> >gv

" }}}

" Set floating terminal size
let g:floaterm_size = 15            " Set the height of the terminal window (in lines)

" Set the key mapping to toggle the terminal (Ctrl-\)
let g:floaterm_keymap_toggle = '<C-\>'

" Set the key mapping to open a new terminal
let g:floaterm_keymap_new = '<C-n>'

" Set the key mapping to navigate between terminals
let g:floaterm_keymap_prev = '<C-p>'

" Set terminal to start in insert mode
let g:floaterm_start_in_insert = 1

" Hide numbers in the terminal window
let g:floaterm_hide_numbers = 1

" Enable the terminal to persist size between sessions
let g:floaterm_persist_size = 1

" Configure the terminal shell (optional, by default Vim uses 'shell')
let g:floaterm_shell = '/bin/zsh'  " You can replace with your shell path (e.g., /bin/zsh)

" Enable floating terminal window shading (this can be customized)
let g:floaterm_shading = 2          " Set shading factor, adjust as needed (0 - 10)

" Configure the border style of the floating terminal (optional)
let g:floaterm_border = 'rounded'   " Options: 'single', 'double', 'rounded'

" Customize terminal behavior to close on exit (optional)
let g:floaterm_close_on_exit = 0    " Set to 1 to close terminal automatically on exit

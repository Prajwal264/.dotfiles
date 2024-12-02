" Define highlight group for yanked text
highlight YankHighlight ctermbg=yellow guibg=yellow

" Automatically highlight yanked text
augroup highlightyank
  autocmd!
  autocmd TextYankPost * silent! call HighlightYankedText()
augroup END

" Function to highlight yanked text
function! HighlightYankedText()
  let old_search = &hlsearch
  set hlsearch
  redraw!
  sleep 300m
  let &hlsearch = old_search
endfunction

" Automatically kill terminal buffers when closed
command Z w | qa
cabbrev wqa Z

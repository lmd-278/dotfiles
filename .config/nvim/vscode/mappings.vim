" Set leader key
let mapleader=" "
nnoremap <Space> <Nop>

" ============================================================================ "
" ===                              Functions                               === "
" ============================================================================ "

function! s:split(...) abort
    let direction = a:1
    let file = exists('a:2') ? a:2 : ''
    call VSCodeCall(direction ==# 'h' ? 'workbench.action.splitEditorDown' : 'workbench.action.splitEditorRight')
    if !empty(file)
        call VSCodeExtensionNotify('open-file', expand(file), 'all')
    endif
endfunction

function! s:splitNew(...)
    let file = a:2
    call s:split(a:1, empty(file) ? '__vscode_new__' : file)
endfunction

function! s:closeOtherEditors()
    call VSCodeNotify('workbench.action.closeEditorsInOtherGroups')
    call VSCodeNotify('workbench.action.closeOtherEditors')
endfunction

function! s:manageEditorHeight(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewHeight' : 'workbench.action.decreaseViewHeight')
    endfor
endfunction

function! s:manageEditorWidth(...)
    let count = a:1
    let to = a:2
    for i in range(1, count ? count : 1)
        call VSCodeNotify(to ==# 'increase' ? 'workbench.action.increaseViewWidth' : 'workbench.action.decreaseViewWidth')
    endfor
endfunction

function! s:vscodeCommentary(...) abort
    if !a:0
        let &operatorfunc = matchstr(expand('<sfile>'), '[^. ]*$')
        return 'g@'
    elseif a:0 > 1
        let [line1, line2] = [a:1, a:2]
    else
        let [line1, line2] = [line("'["), line("']")]
    endif

    call VSCodeCallRange('editor.action.commentLine', line1, line2, 0)
endfunction

" ============================================================================ "
" ===                               Mappings                               === "
" ============================================================================ "

" Better indenting
vnoremap < <gv
vnoremap > >gv

" Move selected line / block of text in visual mode
xnoremap K :move '<-2<CR>gv=gv
xnoremap J :move '>+1<CR>gv=gv

" Simulate same TAB behavior in VSCode
nmap <Tab> :Tabnext<CR>
nmap <S-Tab> :Tabprev<CR>

" Better navigation
nnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
xnoremap <C-j> <Cmd>call VSCodeNotify('workbench.action.navigateDown')<CR>
nnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
xnoremap <C-k> <Cmd>call VSCodeNotify('workbench.action.navigateUp')<CR>
nnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
xnoremap <C-h> <Cmd>call VSCodeNotify('workbench.action.navigateLeft')<CR>
nnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>
xnoremap <C-l> <Cmd>call VSCodeNotify('workbench.action.navigateRight')<CR>

" Quick commentary
xnoremap <expr> <leader>/ <SID>vscodeCommentary()
nnoremap <expr> <leader>/ <SID>vscodeCommentary() . '_'

" Vim-commentary motions
xmap gc  <Plug>VSCodeCommentary
nmap gc  <Plug>VSCodeCommentary
omap gc  <Plug>VSCodeCommentary
nmap gcc <Plug>VSCodeCommentaryLine

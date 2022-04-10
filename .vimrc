set encoding=utf-8
syntax enable
set number
let mapleader=";"

call plug#begin('~/.vim/plugged')

" Run asynchronous tasks
Plug 'skywind3000/asyncrun.vim'
" Code completion
Plug 'neoclide/coc.nvim', {'branch': 'release'}
" Fuzzy finder for files, methods and etc.
Plug 'Yggdroot/LeaderF'
" Tree explorer
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Show the result of git diff
Plug 'mhinz/vim-signify'
" Type AA, AV, AS to switch between *.h and *.cc files with the same name
Plug 'vim-scripts/a.vim'
" Lean & mean status/tabline for vim that's light as air.
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" Highlight for *.md files
Plug 'plasticboy/vim-markdown'

call plug#end()

"" Common configs
set background=dark
set confirm
filetype indent on
set visualbell
set vb t_vb=
set tabstop=4
set shiftwidth=4
set expandtab
set number
set hlsearch
set incsearch
set backspace=2
set whichwrap+=<,>,h,l
set fillchars=vert:\ ,stl:\ ,stlnc:\
set showmatch
set matchtime=1
set scrolloff=3
set foldenable
set foldmethod=syntax
set foldlevel=3
set nofoldenable
set fileencodings=utf-8,gbk,big5
set nobackup
set noswapfile

inoremap ( ()<ESC>i
inoremap [ []<LEFT>
inoremap " ""<ESC>i
inoremap ' ''<ESC>i
inoremap { {}<ESC>i
inoremap {<CR> {<CR>}<ESC>O

function! ClosePair(char)
    if getline('.')[col('.') - 1] == a:char
        return "\<Right>"
    else
        return a:char
    endif
endfunction
                            
inoremap ) <c-r>=ClosePair(')')<CR>
inoremap } <c-r>=ClosePair('}')<CR>
inoremap ] <c-r>=ClosePair(']')<CR>

autocmd BufNewFile *.cc,*.cpp,*.c,*.sh exec ":call SetTitle()"
function SetTitle()
    if &filetype == 'cpp'
        call setline(1, "#include <iostream>")
        call setline(2, "using namespace std;")
        call setline(3, "")
        call setline(4, "int main(int argc, char* argv[]) {")
        call setline(5, "    return 0;")
        call setline(6, "}")
    elseif &filetype == 'c'
        call setline(1, "#include <stdio.h>")
        call setline(2, "#include <stdlib.h>")
        call setline(3, "")
        call setline(4, "int main(int argc, char* argv[]) {")
        call setline(5, "  return 0;")
        call setline(6, "}")
    elseif &filetype == 'sh'
        call setline(1, "#!/bin/bash")
        call setline(2, "set -e")
        call setline(3, "cd `dirname $0`")
    endif
    autocmd BufNewFile * normal G
endfunction

autocmd BufNewFile *.h exec ":call SetTitleForH()"
function SetTitleForH()
    let prefix = ""
    let name = toupper(prefix.expand("%"))
    let name = join(split(name, '\.'), '_')
    let name = join(split(name, '-'), '_')
    call setline(1, join(['#ifndef', name]))
    call setline(2, join(['#define', name]))
    call setline(3, join(['#endif  //', name]))
    exec ":2"
endfunction

"" coc.nvim
" TextEdit might fail if hidden is not set.
set hidden

" Some servers have issues with backup files, see #649.
set nobackup
set nowritebackup

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<C-m>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-x> to trigger completion because <c-space> has conflict with input.
inoremap <silent><expr> <c-x> coc#refresh()

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server.
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Use CTRL-S for selections ranges.
" Requires 'textDocument/selectionRange' support of language server.
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call     CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"" LeaderF
" Ctrl+P: search files in current project directory
" Ctrl+F: search functions
let g:Lf_ShortcutF = '<c-p>'
let g:Lf_ShortcutB = '<m-n>'
noremap <c-f> :LeaderfFunction<cr>
noremap <c-n> :LeaderfMru<cr>
noremap <m-p> :LeaderfFunction!<cr>
noremap <m-n> :LeaderfBuffer<cr>
noremap <m-m> :LeaderfTag<cr>
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}


"" nerdtree
nmap <Leader><Leader> :NERDTreeToggle<CR>
let NERDTreeWinSize=32
let NERDTreeWinPos="right"
let NERDTreeShowHidden=1
let NERDTreeMinimalUI=1

"" vim-signify
set signcolumn=yes

"" async-run
let g:asyncrun_open = 6
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
let g:asyncrun_rootmarks = ['.svn', '.git', '.root', '_darcs', 'build.xml'] 
nnoremap <silent> <F7> :AsyncRun -cwd=<root> make <cr>
map <F5> :call RunProgram()<CR>
func! RunProgram()
    exec "w"
    if &filetype == 'go'
        exec "!go run %"
    elseif &filetype == 'cpp'
        exec "AsyncRun g++ -std=c++11 -Wall \"$(VIM_FILEPATH)\" && ./a.out"
    elseif &filetype == 'c'
        exec "AsyncRun gcc -std=c99 -Wall \"$(VIM_FILEPATH)\" && ./a.out"
    elseif &filetype == 'rs'
        exec "!cargo run"
    elseif index(['python', 'ruby', 'sh'], &filetype) >= 0
        exec "AsyncRun chmod u+x % && ./%"
    endif
endfunc
map <F12> :call ClangFormatMySelf()<CR>
func! ClangFormatMySelf()
    exec "w"
    exec "AsyncRun clang-format-5.0 -i %"
    exec "e"
    exec "call asyncrun#quickfix_toggle(6)"
endfunc


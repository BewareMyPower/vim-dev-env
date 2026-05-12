syntax on
let mapleader = ";"

" IMPORTANT: Set coc.nvim config BEFORE loading the plugin
let g:coc_default_semantic_highlight_groups = 1

call plug#begin('~/.vim/plugged')

Plug 'neoclide/coc.nvim', {'branch': 'release'}
""Plug 'fatih/vim-go'
Plug 'DanBradbury/copilot-chat.vim'

Plug 'Yggdroot/LeaderF'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'skywind3000/asyncrun.vim'
Plug 'vim-scripts/a.vim'
Plug 'preservim/vim-markdown'
Plug 'vim-airline/vim-airline'
Plug 'zivyangll/git-blame.vim'

Plug 'uiiaoo/java-syntax.vim'
Plug 'bfrg/vim-c-cpp-modern'
Plug 'rust-lang/rust.vim'

Plug 'mhinz/vim-signify'
Plug 'sickill/vim-monokai'
Plug 'raphamorim/lucario'
Plug 'srcery-colors/srcery-vim'
Plug 'flazz/vim-colorschemes'
""Plug 'pseewald/vim-anyfold'

call plug#end()

set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}
set signcolumn=yes  " 强制显示侧边栏，防止时有时无

""set background=dark
""colorscheme srcery
colorscheme monokai
""colorscheme lucario
""colorscheme industry

""" 1. The keywords: 'class', 'interface', 'enum'
""hi javaStructure guifg=#5e81ac ctermfg=67 gui=none
""
""" 2. The Class Name: 'UrsaPartitionLogManager' (and types like String, int)
""hi javaType guifg=#eceff4 ctermfg=255 gui=bold
""
""" 3. The keywords: 'public', 'private', 'static'
""hi javaStorageClass guifg=#5e81ac ctermfg=67 gui=none
""
""" 4. The Methods
""hi javaMethod guifg=#81a1c1 ctermfg=109

" Define colors for C++ semantic token types
" NOTE: coc.nvim uses pattern CocSemType{TokenType}_{bufnr} for text properties
" We define base colors and then link the specific types

" Base highlight groups for semantic tokens
highlight CocSemType guifg=#11FF11 ctermfg=Green gui=bold
highlight CocSemClass guifg=#00FF00 ctermfg=Green gui=bold  
highlight CocSemStruct guifg=#00FF00 ctermfg=Green gui=bold
highlight CocSemVariable guifg=#FF4466 ctermfg=Red
highlight CocSemField guifg=#FF0000 ctermfg=Red
highlight CocSemProperty guifg=#FF0000 ctermfg=Red

" Link the actual text property types used by coc.nvim
" These are the names that actually appear in prop_list()
highlight link CocSemTypeClass CocSemClass
highlight link CocSemTypeStruct CocSemStruct  
highlight link CocSemTypeProperty CocSemProperty
highlight link CocSemTypeVariable CocSemVariable
highlight link CocSemTypeField CocSemField

" Link modifiers (these add additional context)
highlight link CocSemTypeModClassGlobalScope CocSemClass
highlight link CocSemTypeModPropertyDeclaration CocSemProperty

" Namespace highlighting
highlight link CocSemNamespace PreProc
highlight link CocSemTypeNamespace PreProc

" For the 'struct' keyword itself
hi link cppStructure Keyword

hi cType ctermfg=Blue guifg=#0044FF
hi cppType ctermfg=Blue guifg=#00AAFF
hi cppSTLtype ctermfg=Blue guifg=#3366FF
highlight cppStructure guifg=#BD93F9 ctermfg=Magenta gui=bold
highlight cTypeName guifg=#8BE9FD ctermfg=Cyan
hi cppMember ctermfg=Green guifg=#00FF00
hi cppSTLnamespace ctermfg=Green guifg=#44FF44

"""""""""""""""""""""""""""""
" coc.nvim
"""""""""""""""""""""""""""""
" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

set hidden
set cmdheight=2
set shortmess+=c

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent><nowait> [g <Plug>(coc-diagnostic-prev)
nmap <silent><nowait> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent><nowait> gd <Plug>(coc-definition)
nmap <silent><nowait> gy <Plug>(coc-type-definition)
nmap <silent><nowait> gi <Plug>(coc-implementation)
nmap <silent><nowait> gr <Plug>(coc-references)
nmap <silent><nowait> rr <Plug>(coc-rename)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>

"""""""""""""""""""""""""""""
" vim-go
"""""""""""""""""""""""""""""
""let g:go_install_binaries = ['/opt/homebrew/bin/go']
""let g:go_lsp_binary = '/opt/homebrew/bin/gopls'
""let g:go_bin_path = ''
""let g:go_imports_autosave = 0
""au BufWritePre,FileWritePre *.go :GoFmt


"""""""""""""""""""""""""""""
" LeaderF
"""""""""""""""""""""""""""""
let g:Lf_UseCache = 0
" Ctrl+P在当前项目目录打开文件搜索, Ctrl+N打开MRU搜索，搜索最近打开的文件
" Alt+P打开函数搜索，Alt+N打开Buffer搜索
let g:Lf_ShortcutF = '<c-p>'
let g:Lf_ShortcutB = '<m-n>'
" Ctrl+F 使用正则模糊匹配查找函数，按 Ctrl+K/J 上下移动，按 TAB
" 后查找窗口会变成普通模式，直接 K/J 或者方向键即可上下移动
noremap <c-f> :LeaderfFunction<cr>
" Ctrl+P 使用正则模糊匹配查找文件
noremap <c-n> :LeaderfMru<cr>
noremap <m-p> :LeaderfFunction!<cr>
noremap <m-n> :LeaderfBuffer<cr>
noremap <m-m> :LeaderfTag<cr>
let g:Lf_StlSeparator = { 'left': '', 'right': '', 'font': '' }

let g:Lf_RootMarkers = ['.project', '.root', '.svn', '.git']
""let g:Lf_WorkingDirectoryMode = 'Ac'
let g:Lf_WindowHeight = 0.30
let g:Lf_CacheDirectory = expand('~/.vim/cache')
let g:Lf_ShowRelativePath = 0
let g:Lf_HideHelp = 1
let g:Lf_StlColorscheme = 'powerline'
let g:Lf_PreviewResult = {'Function':0, 'BufTag':0}


"""""""""""""""""""""""""""""""""
"" nerdtree
"""""""""""""""""""""""""""""""""
nmap <Leader><Leader> :NERDTreeToggle<CR>
let NERDTreeWinSize=32          " 设置NERDTree子窗口宽度
let NERDTreeWinPos="right"      " 设置NERDTree子窗口位置
let NERDTreeShowHidden=1        " 显示隐藏文件
let NERDTreeMinimalUI=1         " NERDTree 子窗口中不显示冗余帮助信息
let NERDTreeAutoDeleteBuffer=1  " 删除文件时自动删除文件对应 buffer


"""""""""""""""""""""""""""""
" Others
"""""""""""""""""""""""""""""
let g:asyncrun_open = 15
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>
map <F12> :call FormatFile()<CR>
func! FormatFile()
    exec "w"
    if &filetype == 'go'
        exec "!gofmt -i %"
    elseif &filetype == 'java'
        exec "AsyncRun mvn spotless:apply"
        exec "e"
        exec "call asyncrun#quickfix_toggle(6)"
    elseif &filetype == 'cpp'
        exec "AsyncRun clang-format-11 -i %"
        exec "e"
        exec "call asyncrun#quickfix_toggle(6)"
    elseif &filetype == 'c'
        exec "AsyncRun clang-format-11 -i %"
        exec "e"
        exec "call asyncrun#quickfix_toggle(6)"
    elseif &filetype == 'rust'
        ""exec "!rustfmt --edition=2024 %"
        exec '!cargo fmt -- %'
    endif
endfunc

"" git-blame
nnoremap <Leader>s :<C-u>call gitblame#echo()<CR>

"" --------------------------------------------------
"" 下列配置均为插件无关的代码，放到最末尾
"" --------------------------------------------------
" 设置背景是黑色
set confirm
filetype indent on
" 禁止铃声
""set visualbell
" 在处理未保存或只读文件的时候，弹出确认
set confirm
" 自适应不同语言的智能缩进
filetype indent on
" 设置编辑时制表符占用空格数
set tabstop=4
" 设置格式化时制表符占用空格数
set shiftwidth=4
" 将制表符扩展为空格
set expandtab
" 让 vim 把连续数量的空格视为一个制表符
"set softtabstop=4
" 显示行号
set number
"搜索忽略大小写
"set ignorecase
"搜索逐字符高亮
set hlsearch
set incsearch
" 使回格键（backspace）正常处理indent, eol, start等
set backspace=2
" 允许backspace和光标键跨越行边界
set whichwrap+=<,>,h,l
" 在被分割的窗口间显示空白，便于阅读
set fillchars=vert:\ ,stl:\ ,stlnc:\
" 高亮显示匹配的括号
set showmatch
" 匹配括号高亮的时间（单位是十分之一秒）
set matchtime=1
" 光标移动到buffer的顶部和底部时保持3行距离
set scrolloff=3
" 启用折叠
""set foldenable
""" 基于语法的代码折叠
"" NOTE: this is too slow, see https://stackoverflow.com/questions/48679821/set-foldmethod-syntax-makes-vim-slower-and-set-foldmethod-indent-is-not-goo
""set foldmethod=syntax
""" 最高折叠层数
""set foldlevel=3
set nofoldenable

" Fix C/C++ syntax synchronization to prevent false comment detection
autocmd FileType c,cpp syntax sync fromstart
" Alternatively, for better performance on large files:
" autocmd FileType c,cpp syntax sync minlines=500
" 识别各种编码
set fileencodings=utf-8,gbk,big5
" 禁止生成临时文件
set nobackup
set noswapfile

" 括号补全
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

" 代码模板
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
    " 新建文件后自动定位到文件末尾
    autocmd BufNewFile * normal G
endfunction

autocmd BufNewFile *.h exec ":call SetTitleForH()"
function SetTitleForH()
    " 比如 xxx_yyy.h，对应的 if-guard 宏是 XXX_YYY_H，如果要加上项目名特定前缀，
    " 比如项目 xyz 的每个头文件宏都是以 XYZ_ 作为开头，修改下面的 prefix 变量
    let prefix = ""
    let name = toupper(prefix.expand("%"))
    let name = join(split(name, '\.'), '_')
    let name = join(split(name, '-'), '_')
    call setline(1, join(['#ifndef', name]))
    call setline(2, join(['#define', name]))
    call setline(3, join(['#endif  //', name]))
    exec ":2"
endfunction

function! GetHigh()
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
    \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
    \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunction

" Command to force syntax refresh if highlighting breaks
""command! SyntaxRefresh syntax sync fromstart

""" vim-anyfold
""autocmd Filetype * AnyFoldActivate
""let g:anyfold_fold_comments=1
""set foldlevel=0
""hi Folded term=NONE cterm=NONE

set nocompatible               " be iMproved
filetype off                   " required!

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

runtime macros/matchit.vim

Plugin 'vim-ruby/vim-ruby'
Plugin 'tomtom/tcomment_vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'nono/vim-handlebars'
Plugin 'bronson/vim-trailing-whitespace'
Plugin 'git://git.wincent.com/command-t.git'
Plugin 'mileszs/ack.vim'
Plugin 'vimwiki/vimwiki'
Plugin 'benmills/vimux'

Plugin 'tpope/vim-bundler'
Plugin 'kana/vim-textobj-user'
Plugin 'nelstrom/vim-textobj-rubyblock'
Plugin 'altercation/vim-colors-solarized.git'
Plugin 'Lokaltog/powerline', {'rtp': 'powerline/bindings/vim/'}
Plugin 'tpope/vim-fugitive'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-fireplace'
Plugin 'tpope/vim-classpath'
Plugin 'kien/rainbow_parentheses.vim'
Plugin 'Shutnik/jshint2.vim'
Plugin 'vim-scripts/Align'
Plugin 'vim-scripts/SQLUtilities'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'

call vundle#end()

set hlsearch
set number

vnoremap . :norm.<CR>
syntax on
filetype plugin indent on
set noswapfile
set hidden
set autoread

set ts=2
set expandtab
set tabstop=2
set shiftwidth=2
set autoindent
set smartindent
" make searches case-sensitive only if they contain upper-case characters
set ignorecase smartcase
set cmdheight=1
set switchbuf=useopen
set numberwidth=5
set showtabline=2
set winwidth=79
" This makes RVM work inside Vim. I have no idea why.
let mapleader=","
let maplocalleader="\\"
nnoremap <leader><leader> <c-^>

augroup filetypedetect
	  au! BufRead,BufNewFile *nc setfiletype nc
augroup END

au BufRead,BufNewFile *.es6 set filetype=javascript

" possibly not needed
noremap <silent> <F11> :cal VimCommanderToggle()<CR>

" status line customization
let g:Powerline_symbols = 'fancy'
set laststatus=2

set ai
set si
set t_Co=256 " 256 colors
set background=dark
let g:solarized_termcolors=256
colorscheme solarized
set term=xterm-256color
set termencoding=utf-8


" open files in directories of current file
cnoremap %% <C-R>=expand('%-h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%

" Gary Bernhardt stuff ---------------------- {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Some stuff from Gary Bernhardt follows
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" rename current file
function! RenameFile()
  let old_name = expand('%')
  let new_name = input('New file name: ', expand('%'))
  if new_name != '' && new_name != old_name
    exec ':saveas ' . new_name
    exec ':silent !rm ' . old_name
    redraw!
  endif
endfunction
map <leader>n :call RenameFile()<cr>



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CUSTOM AUTOCMDS
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ruby,haml,eruby,yaml,html,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

augroup END

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" STATUS LINE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" PROMOTE VARIABLE TO RSPEC LET
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! PromoteToLet()
  :normal! dd
  " :exec '?^\s*it\>'
  :normal! P
  :.s/\(\w\+\) = \(.*\)$/let(:\1) { \2 }/
  :normal ==
endfunction
:command! PromoteToLet :call PromoteToLet()
":map <leader>p :PromoteToLet<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" MAPS TO JUMP TO SPECIFIC COMMAND-T TARGETS AND FILES
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <leader>gr :topleft :split config/routes.rb<cr>
function! ShowRoutes()
  " Requires 'scratch' plugin
  :topleft 100 :split __Routes__
  " Make sure Vim doesn't write __Routes__ as a file
  :set buftype=nofile
  " Delete everything
  :normal 1GdG
  " Put routes output in buffer
  :0r! rake -s routes
  " Size window to number of lines (1 plus rake output length)
  :exec ":normal " . line("$") . _ "
  " Move cursor to bottom
  :normal 1GG
  " Delete empty trailing line
  :normal dd
endfunction
nnoremap <leader>gR :call ShowRoutes()<cr>
nnoremap <leader>gv :CommandTFlush<cr>\|:CommandT app/views<cr>
nnoremap <leader>gc :CommandTFlush<cr>\|:CommandT app/controllers<cr>
nnoremap <leader>gm :CommandTFlush<cr>\|:CommandT app/models<cr>
nnoremap <leader>gh :CommandTFlush<cr>\|:CommandT app/helpers<cr>
nnoremap <leader>gl :CommandTFlush<cr>\|:CommandT lib<cr>
nnoremap <leader>gp :CommandTFlush<cr>\|:CommandT app/assets<cr>
nnoremap <leader>gs :CommandTFlush<cr>\|:CommandT app/assets/stylesheets/sass<cr>
nnoremap <leader>gf :CommandTFlush<cr>\|:CommandT features<cr>
nnoremap <leader>gg :topleft 100 :split Gemfile<cr>
nnoremap <leader>gt :CommandTFlush<cr>\|:CommandTTag<cr>
nnoremap <leader>f :CommandTFlush<cr>\|:CommandT<cr>
nnoremap <leader>F :CommandTFlush<cr>\|:CommandT %%<cr>
let g:CommandTTraverseSCM='pwd'


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SWITCH BETWEEN TEST AND PRODUCTION CODE
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>

" }}}

" global mappings ---------------------- {{{

inoremap jk <Esc>

" remove search highlight
nnoremap <CR> :nohlsearch<cr>
" move lines
nnoremap - ddp
nnoremap _ ddkP

" edit vim rc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

"abbreviations as spell correct
iabbrev lenght length

" surround in quotes TODO remove
nnoremap <leader>" viw<esc>a"<esc>hbi"<esc>lel
nnoremap <leader>' viw<esc>a'<esc>hbi'<esc>lel
vnoremap <leader>" <esc>`<i"<esc>`>la"<esc>

nnoremap K <silent>

" adding movements
" inside next parens
onoremap in( :<c-u>normal! f(vi(<cr>
" inside last parens
onoremap il( :<c-u>normal! F)vi(<cr>


" Vimscript file settings ---------------------- {{{
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END
" }}}


" inspect a gem
command! -nargs=* -complete=custom,ListGems BundleOpen silent execute "!bundle open <args>"

" The function used to produce the autocomplete results.
fun! ListGems(A,L,P)
  " Note that vim will filter for us... no need to do anything with A args.
  return system("grep -s '^ ' Gemfile.lock | sed 's/^ *//' | cut -d ' '  -f1 | sed 's/!//' | sort | uniq")
endfun

" Shortcut mapping.
nmap <leader>o :BundleOpen

" ack search current word in project
nnoremap <leader>a "ayw:Ack <C-R>a
vnoremap <leader>a "ay:Ack <C-R>a

" SOURCE a local vimfile
if filereadable(glob(".vimrc.local"))
      source .vimrc.local
endif

set pastetoggle=<leader>y

nnoremap  <leader>t :tabnew<cr>
nnoremap  <leader>s :vs<cr>
nnoremap  <leader>w :sv<cr>

function! s:ChangeHashSyntax(line1,line2)
    let l:save_cursor = getpos(".")
    silent! execute ':' . a:line1 . ',' . a:line2 . 's/:\([a-z0-9_]\+\)\s\+=>/\1:/g'
    call setpos('.', l:save_cursor)
endfunction

command! -range=% ChangeHashSyntax call <SID>ChangeHashSyntax(<line1>,<line2>)

set wildignore+=*.o,*.obj,.git,node_modules,bower_components,tmp

au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

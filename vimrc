" An example for a vimrc file.
"
" Maintainer:	Bram Moolenaar <Bram@vim.org>
" Last change:	2011 Apr 15
"
" To use it, copy it to
"     for Unix and OS/2:  ~/.vimrc
"	      for Amiga:  s:.vimrc
"  for MS-DOS and Win32:  $VIM\_vimrc
"	    for OpenVMS:  sys$login:.vimrc

" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
  finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

if has("vms")
  set nobackup		" do not keep a backup file, use versions instead
else
  set backup		" keep a backup file
endif
set history=1000		" keep 50 lines of command line history
set ruler		" show the cursor position all the time
set showcmd		" display incomplete commands
set incsearch		" do incremental searching

" For Win32 GUI: remove 't' flag from 'guioptions': no tearoff menu entries
" let &guioptions = substitute(&guioptions, "t", "", "g")

" Don't use Ex mode, use Q for formatting
map Q gq

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
  set mouse=a
endif

" Switch syntax highlighting on, when the terminal has colors
" Also switch on highlighting the last used search pattern.
if &t_Co > 2 || has("gui_running")
  syntax on
  set hlsearch
endif

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  " Also don't do it when the mark is in the first line, that is the default
  " position when opening a file.
  autocmd BufReadPost *
    \ if line("'\"") > 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
		  \ | wincmd p | diffthis
endif 

""===============================================================
set number
"set autochdir

set laststatus=2
"set statusline=\ %<%F%m[%1*%M%*%n%H]%=\ %y\ %0(%{&fileformat}\ \ %c,%l/%L%)
set statusline=\ %<%F%m%=[%-.50{CurDir()}]\ \ %c,\ %l/%L\ \ %p%%\ 

function! CurDir()
	let curdir = substitute(getcwd(), $HOME, "~", "g")
	return curdir
endfunction

let mapleader = ","
nmap <Leader>w	:w<CR>
nmap <Leader>q	:q<CR>
"nmap <Leader>x	:x<CR>


set tabstop=4
set softtabstop=4
set shiftwidth=4
set smartindent
set smarttab

"set term=$XTERM
"set ttymouse=xterm2
"
"" disable beeping instead visual bell
set vb t_vb=
set scrolloff=5
set sidescroll=10
"" buffer
set hidden
set diffopt=filler,vertical
"set nowrap
"set nobuflisted
"" ask to confirm when abandan a unsaved buffer 
set confirm

if has("gui_running")
	set macmeta  "" Macvim only
	colorscheme evening
	set cursorline
	set guifont=courier_new:h11
	set guicursor=a:blinkon0
	set guioptions=eac
	set lines=60 columns=150
endif


""""""""""" Normal mode key mapping 
" make Y consistent with C and D
noremap Y	y$
" switch window 
nmap <A-h>  <C-W>h
nmap <A-j>  <C-W>j
nmap <A-l>  <C-W>l
nmap <A-k>  <C-W>k
"" move cursor and scroll screen vertical
nmap <C-L>	<C-Y>
nmap <C-H>	<C-E>
nmap <C-K>	{
nmap <C-J>	}
"" page up/half page up, page down
nmap <SPACE>	<C-F>
nmap <BS>		<C-B>
noremap J	<C-D>
noremap K	<C-U>
"" swith tabs
noremap <A-n>	gt
noremap <A-p>	gT
"noremap <C-Space>	g#
"" shortcut for command
nmap <Leader>h	:vertical help<Space>
nmap <Leader>t	:tabedit<Space>
nmap <Leader>e	:e<Space>
"" :w !sudo tee %
nmap <Leader>sw	:w !sudo tee %<CR>
""
"" shourt for buffer operations
"nmap <S-TAB>	:bp<CR>
"nmap <TAB>		:bn<CR>
nmap <A-SPACE>	:b#<CR>
nmap <Leader>l	:ls<CR>
nmap <Leader>d	:buffers<CR>:bun<Space>
nmap <Leader>b	:buffers<CR>:buffer<Space>
nmap <Leader>sb	:buffers<CR>:sb<Space>
""
"" keymappig for register operations
noremap <Leader>r	:registers<CR>
"" 
"nmap <Leader>,	:source ~/.vimrc<CR>
nmap <Leader>x	:!
"
" resize window 
nmap +	<C-w>3+
nmap -	<C-w>3-
nmap <	<C-w>3<
nmap >	<C-w>3>
nmap =	<C-w>=


"" key mapping for Insert mode
""  exit insert mode to normal mode
inoremap jj		<Esc>
""
imap <C-a>	<Home>
imap <C-e>	<End>
imap <C-D>	<Del>
""  
imap <A-h>	<Left>
imap <A-j>	<Down>
imap <A-k>	<Up>
imap <A-l>	<Right>
"
inoremap <A-a>	<Home>
inoremap <A-e>	<End>
inoremap <A-b>	<S-Left>
inoremap <A-f>	<S-Right>
inoremap <S-BS>	<C-w>
""
imap <A-d>	<S-Right><C-w>



"" key mapping for command line mode 
"" exit command mode to normal mode 
cmap jj		<C-c>
""
""cnoremap <C-A>	<Home>
""cnoremap <C-E>	<End>
""cnoremap <C-B>	<Left>
""cnoremap <C-F>	<Right>
""cnoremap <A-B>	<Left>
""cnoremap <A-F>	<Right>
"cnoremap <C-A>	<Home>
" only for Macvim <D-Left> D is Command key
cmap <C-A>	<D-Left>
cmap <C-E>	<D-Right>
cmap <A-a>	<D-Left>
cmap <A-e>	<D-Right>
""
cnoremap <C-F>	<Right>
cnoremap <C-B>	<Left>
cnoremap <A-b>	<S-Left>
cnoremap <A-f>	<S-Right>
"
" delet a word left of cursor
cmap <S-BS>	<C-w>
cmap <A-d>	<S-Right><S-Right><S-Left><C-w>



"" key mapping for  visul mode
vmap <C-k>	{	
vmap <C-j>	}	



""================================
"autocmd BufEnter *.log set guifont=courier_new:h12
"augroup filetypedetect
"au BufNewFile,BufRead *.log source ~/.vim/ftplugin/logfile.vim
"au BufNewFile,BufRead *.log.[0-9] source ~/.vim/ftplugin/logfile.vim
"augroup END
""=========================

" If doing a diff. Upon writing changes to file, automatically update the
" differences
" http://vim.wikia.com/wiki/Update_the_diff_view_automatically
autocmd InsertLeave,BufWritePost,CursorHold * if &diff == 1 | diffupdate | endif

" setlocal nomodifiable for svn diff
autocmd BufWinEnter *.svn-base setlocal nomodifiable 
" in help windows press q to quit
autocmd BufRead $VIMRUNTIME/doc/*.txt noremap <buffer> <silent> q :q<CR>
autocmd BufRead "$HOME/.vim/doc/*.txt" noremap <buffer> <silent> q :q<CR>


"" ===============================================================================
"	some tips for remapping
"	
"	insert mode ,	jj		return normal mode
"	command mode ,	jj		return normal mode
"
"
"
"cmap <TAB>	<C-d>
"cnoremap <TAB><TAB>	<TAB>
"set wildmode=list:longest
set wildmenu
set wildignore=*.o,*.obj,*~,*.swp

""""================================================================================""""
""""========================== Tcd =================================================""""
""""================================================================================""""
"" alias :cd to :Tcd to change current tab directory
cabbrev cd Tcd


""""================================================================================""""
""""======================= NerdTree configurations ================================""""
""""================================================================================""""
nmap <Leader>n	:NERDTreeToggle<CR>


""""================================================================================""""
""""======================== showmarks / marksbrowser configuration ================""""
""""================================================================================""""
"http://blog.chinaunix.net/uid-13701930-id-336505.html
"                Default keymappings are:
"                  <Leader>mt  - Toggles ShowMarks on and off.
"                  <Leader>mo  - Turns ShowMarks on, and displays marks.
"                  <Leader>mh  - Clears a mark.
"                  <Leader>ma  - Clears all marks.
"                  <Leader>mm  - Places the next available mark.
" showmarks setting
""""""""""""""""""""""""""""""
" Enable ShowMarks
let showmarks_enable = 0
" Show which marks
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1
hi ShowMarksHLl ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi ShowMarksHLu ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
"
noremap <Leader>m	:MarksBrowser<CR>
"noremap \m	:marks<CR>:normal `


""""================================================================================""""
""""======================= FuzzyFinder configuration ==============================""""
""""================================================================================""""
""  FuzzyFinder example vimrc 
  let g:fuf_modesDisable = []
  let g:fuf_mrufile_maxItem = 400
  let g:fuf_mrucmd_maxItem = 400
  nnoremap <silent> sj     :FufBuffer<CR>
  nnoremap <silent> sK     :FufFileWithCurrentBufferDir<CR>
  nnoremap <silent> sk     :FufFileWithFullCwd<CR>
  nnoremap <silent> s<C-k> :FufFile<CR>
  nnoremap <silent> sl     :FufCoverageFileChange<CR>
  nnoremap <silent> sL     :FufCoverageFileChange<CR>
  nnoremap <silent> s<C-l> :FufCoverageFileRegister<CR>
  nnoremap <silent> sd     :FufDirWithCurrentBufferDir<CR>
  nnoremap <silent> sD     :FufDirWithFullCwd<CR>
  nnoremap <silent> s<C-d> :FufDir<CR>
  nnoremap <silent> sn     :FufMruFile<CR>
  nnoremap <silent> sN     :FufMruFileInCwd<CR>
  nnoremap <silent> sm     :FufMruCmd<CR>
  nnoremap <silent> su     :FufBookmarkFile<CR>
  nnoremap <silent> s<C-u> :FufBookmarkFileAdd<CR>
  vnoremap <silent> s<C-u> :FufBookmarkFileAddAsSelectedText<CR>
  nnoremap <silent> si     :FufBookmarkDir<CR>
  nnoremap <silent> s<C-i> :FufBookmarkDirAdd<CR>
  nnoremap <silent> st     :FufTag<CR>
  nnoremap <silent> sT     :FufTag!<CR>
  nnoremap <silent> s<C-]> :FufTagWithCursorWord!<CR>
  nnoremap <silent> s,     :FufBufferTag<CR>
  nnoremap <silent> s<     :FufBufferTag!<CR>
  vnoremap <silent> s,     :FufBufferTagWithSelectedText!<CR>
  vnoremap <silent> s<     :FufBufferTagWithSelectedText<CR>
  nnoremap <silent> s}     :FufBufferTagWithCursorWord!<CR>
  nnoremap <silent> s.     :FufBufferTagAll<CR>
  nnoremap <silent> s>     :FufBufferTagAll!<CR>
  vnoremap <silent> s.     :FufBufferTagAllWithSelectedText!<CR>
  vnoremap <silent> s>     :FufBufferTagAllWithSelectedText<CR>
  nnoremap <silent> s]     :FufBufferTagAllWithCursorWord!<CR>
  nnoremap <silent> sg     :FufTaggedFile<CR>
  nnoremap <silent> sG     :FufTaggedFile!<CR>
  nnoremap <silent> so     :FufJumpList<CR>
  nnoremap <silent> sp     :FufChangeList<CR>
  nnoremap <silent> sq     :FufQuickfix<CR>
  nnoremap <silent> sy     :FufLine<CR>
  nnoremap <silent> sh     :FufHelp<CR>
  nnoremap <silent> se     :FufEditDataFile<CR>
  nnoremap <silent> sr     :FufRenewCache<CR>
""  FuzzyFinder example vimrc 
""""================================================================================""""
""""================================================================================""""
""""================================================================================""""


""  taglist
let Tlist_Ctags_Cmd="/usr/local/bin/ctags"
":filetype
"
noremap <Leader>f	:TagbarToggle<CR><C-w>l

"
"http://foocoder.com/blog/mei-ri-vimcha-jian-dai-ma-sou-suo-ctlsf-dot-vim.html/
"https://github.com/rking/ag.vim
let g:ackprg = 'ag --nogroup --nocolor --column'

filetype off
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" This is the Vundle package, which can be found on GitHub.
" For GitHub repos, you specify plugins using the
" 'user/repository' format
Plugin 'gmarik/vundle'

filetype plugin indent on
Bundle 'rking/ag.vim'

"""jfojfoejofijeojfoiejfoe

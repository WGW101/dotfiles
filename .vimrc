" When started as "evim", evim.vim will already have done these settings.
if v:progname =~? "evim"
	finish
endif

" Use Vim settings, rather than Vi settings (much better!).
" This must be first, because it changes other options as a side effect.
set nocompatible

" allow backspacing over everything in insert mode
set backspace=indent,eol,start

" Set backup and swap files to be saved to specific directories
" Also take care of writing a backup before overwritting a file
set backup
set backupdir=./.backup,~/.tmp,/tmp
set backupskip=~/.tmp/*,/tmp/*
set directory=./.backup,~/.tmp,/tmp
set writebackup

" Enable folding based on indentation
set foldenable
set foldmethod=manual
set foldnestmax=4
set foldlevelstart=4
nmap z% va}zf

" Keep 50 lines of command line history
set history=50
" Use hidden buffer when working on multiple files
set hidden

" Show the cursor position all the time
set ruler
" Display incomplete commands
set showcmd
" Display menu when autocompleting commands
set wildmenu
" Expand command line to 2 lines to avoid press Enter message
set cmdheight=2
" Always show the status bar
set laststatus=2

" Display line numbers
set number
" Don't redraw when not needed (macro)
set lazyredraw

" Don't emit beeps on errors
set visualbell
set t_vb=

" Use hard tabs displayed as 4 spaces
set noexpandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4
" Keep previous indent for new line
set autoindent
" Maintain selection when indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" Don't use Ex mode, use Q for formatting
map Q gq

" Make Y behave as D or C and use yy for yank line
map Y y$

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

" In many terminal emulators the mouse works just fine, thus enable it.
if has('mouse')
	set mouse=a
endif

" do incremental searching
set incsearch
" ignore case for search...
set ignorecase
" ...except if search pattern contains uppercase letter.
set smartcase

" Only do this part when terminal has color support.
if &t_Co > 2 || has("gui_running")

	" Switch syntax highlighting on
	syntax on

	" Highligh corresponding ( { [
	set showmatch

	" Switch on highlighting the last used search pattern
	set hlsearch

	" Clear highlighting when redrawing
	nnoremap <C-L> :nohlsearch<CR><C-L>

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

endif

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
if !exists(":DiffOrig")
	command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
				\ | wincmd p | diffthis
endif

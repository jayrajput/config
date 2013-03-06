" See http://learnvimscriptthehardway.stevelosh.com
let mapleader      = "\\"
let maplocalleader = "_"
inoremap jk <esc>
inoremap hl <esc>
" <nop> is no operation
inoremap <Down>  <nop> 
inoremap <Up>    <nop> 
inoremap <Left>  <nop> 
inoremap <Right> <nop> 
nnoremap <Down>  <nop> 
nnoremap <Up>    <nop> 
nnoremap <Left>  <nop> 
nnoremap <Right> <nop> 
" mapping for editing and sourcing vimrc
" ev = edit vimrc and sv = source vimrc
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

filetype on
set ignorecase
set incsearch
set nowrap
set textwidth=0
set tabstop=4
set shiftwidth=4
set winminheight=0
set expandtab
set background=dark
set laststatus=2
set scroll=3    " for Control-d and Control-u
set scrolloff=3 " for Control-d and Control-u
set ruler       " to see the column numbers
" cindent overrides smartindent and autoindent.
" I am using cindent also in PHP.
set cindent
" (1s indent one sw from the line with unclosed parentheses.
" m1  line up a line with a closing parentheses with first character of the
"     line with matching opening parentheses.
set cinoptions=(1s,m1
set nu
map <F12> :cn
map <F11> :cp
map  2j
map  2k

" Minimal changes from the defaults; including fg colors in case of syntax highlighting:
:highlight DiffAdd    ctermfg=black ctermbg=green
:highlight DiffDelete ctermfg=black ctermbg=magenta
:highlight DiffChange ctermfg=black ctermbg=gray
:highlight DiffText   ctermfg=black ctermbg=Yellow


function! SyncVob2Target()
python << PYEND
import vim

vob2target={
    "/home/jay/dump" : "/var/TKLC/appworks/dump",
    "/vobs/software/awpss7/diameter/TKLCdpi/gui/modules/diameter/" : "/var/TKLC/appworks/modules/diameter",
    "/vobs/software/awpss7/diameter/TKLCdpi/gui/lib"               : "/var/TKLC/appworks/library/Diameter",
    "/vobs/software/awpss7/diameter/TKLCdpi/gui/javascript"        : "/var/TKLC/appworks/public/js",
}

vobFile      = vim.eval('expand ("%:p")')
targetServer = vim.eval("g:targetServer")

if targetServer is "":
    vim.command("echo 'Target server not set'")
else:
    targetFile = None
    for key in vob2target.keys():
        if vobFile.find(key) != -1:
            targetFile = vobFile.replace(key, vob2target[key])

    cmd = "rsync " + vobFile + " root@" + targetServer + ":" + targetFile
    vim.command("echo '" + cmd + "'")
PYEND
    "os.system(cmd)
endfunction

"let g:targetServer=""
"function! SyncVob2Target()
"    let targetFile = system("/home/jay/dump/vob2target " . expand("%:p"))
"    let l:cmd = "rsync " . expand("%:p") . " root@" . g:targetServer . ":" . targetFile
"    " We need a way to execute a Vim command that refers to a variable instead
"    " of a literal string such as rsync. Vim gives us the execute command
"    " for this purpose. 
"    execute "silent! !" . cmd
"endfunction
function! SetupSync()
    call inputsave()
    let g:targetServer = input('Enter target server: ')
    call inputrestore()
    au BufWritePost *.php,*.phtml,*.js :call SyncVob2Target()
endfunction

function! s:Underline(chars)
  let chars = empty(a:chars) ? '-' : a:chars
  let nr_columns = virtcol('$') - 1
  let uline = repeat(chars, (nr_columns / len(chars)) + 1)
  put =strpart(uline, 0, nr_columns)
endfunction
command! -nargs=? Underline call s:Underline(<q-args>)

" Align plugin
" http://vim.sourceforge.net/scripts/script.php?script_id=294
set nocompatible
filetype plugin on

syntax on

" setting for mouse to work
" use r to allow copy/paste.
" to copy text out of vim use SHIFT with mouse.
" See: http://stackoverflow.com/questions/4608161/copy-text-out-of-vim-with-set-mouse-a-enabled
set ttymouse=xterm2
set mouse=n

" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
nnoremap ,cd :lcd %:p:h<CR>:pwd<CR>

function! MyVerbose()
    set spelllang=en_us
    set spell!
    " Highlight tabs.http://www.paulgraydon.co.uk/geeky/nixtricks/vim-highlight-tabs/
    set lcs=tab:>-,trail:%,eol:$
    set list!
    set comments=s1:/*,mb:*,ex:*/,://,b:#,:%,:XCOMM,n:>,fb:-
endfunction

" See http://vim.wikia.com/wiki/Write_your_own_Vim_function
function! Cd()
    exe "!cdargs"
    let mydir = system("cat /home/raleigh/jrajpu10/.cdargsresult")
    " See http://stackoverflow.com/questions/4596932/vim-cd-to-path-stored-in-variable
    "cd `=mydir`
    edit `=mydir`
endfunction
" Alias to my function so you do not need to type call everytime.
" command Cd call Cd()

" See http://vim.wikia.com/wiki/Managing_set_options
nnoremap <F9>:call ToggleMouse()<CR>

function! ToggleMouse()
  if &mouse == 'a'
    set mouse=
    echo "Mouse usage disabled"
  else
    set mouse=a
    echo "Mouse usage enabled"
  endif
endfunction

" CommandT related setting.
nnoremap <leader>t :CommandT<CR>
nnoremap <leader>b :CommandTBuffer<CR>
let g:CommandTCancelMap='<C-x>'

" Make backspace work in insert mode
" see
" http://vim.wikia.com/wiki/Erasing_previously_entered_characters_in_insert_mode
" setting backspace also make C-w and Control-u works for deleting words.
set backspace=indent,eol,start
set backspace=2

" For Yank-ring
let g:yankring_replace_n_pkey = '<m-p>'
let g:yankring_replace_n_nkey = '<m-n>'

" for tab highlighting.
hi TabLineFill ctermfg=LightGray ctermbg=Black
hi TabLine     ctermfg=LightBlue  ctermbg=Black
hi TabLineSel  ctermfg=LightRed   ctermbg=Black
hi Title       ctermfg=LightBlue  ctermbg=Black

" Make it the last as I have realized that sometimes it does not work.
set expandtab

scriptencoding utf-8
"=============================================================================
"
" Fichier de configuration VIM personnalisé (meilleur pour la programmation,
" raccourcis clavier utiles, etc. pour mieux profiter de cet excellent
" éditeur).
"
" Auteur : Achraf cherti (aka Asher256)
" Email  : achraf at cherti dot name
"
" Licence : GPL
"
" Site: http://achraf.cherti.name/
"
"=============================================================================

"colorscheme nuvola
set t_Co=256

" Options {{{1

" Options Internes {{{2

" Mode non compatible avec Vi
set nocompatible 

" Le backspace
set backspace=indent,eol,start

" Les Tabs
set noet
set sw=4
set ts=4
set sts=4
set tw=79

" Les fenêtres et onglets
set splitright

" Le scroll offset
set scrolloff=5

" Utilise ack-grep au lieu de grep
"set grepprg=ack-grep

" Repli du code
set fdm=syntax

" Dossier contenant les fichiers de configuration
let vimpath = $HOME . "$/.config/vim"

" Activer l'historique
set viminfo='1000,f1,<500
set viminfo+="$HOME/.vim/viminfo"

" Activer la sauvegarde
set backup

" un historique raisonnable
set history=100

" undo, pour revenir en arrière
set undolevels=150

" Suffixes à cacher
set suffixes=.jpg,.png,.jpeg,.gif,.bak,~,.swp,.swo,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc,.pyc,.pyo

" Backup dans ~/.vim/backup
if filewritable($HOME. "/.vim/backup") == 2
    " comme le répertoire est accessible en écriture,
    " on va l'utiliser.
    set backupdir=$HOME/.vim/backup
else
    if has("unix") || has("win32unix")
        " C'est c'est un système compatible UNIX, on
        " va créer le répertoire et l'utiliser.
        call system("mkdir $HOME/.vim/backup -p")
        set backupdir=$HOME/.vim/backup
    endif
endif

" Inclusion d'un autre fichier avec des options
if filereadable($HOME."/.vimrc_local.vim")
    source $HOME/.vimrc_local.vim
endif

" Activation de la syntaxe
if has("syntax")
    syntax on
endif

" Quand un fichier est changé en dehors de Vim, il est relu automatiquement
set autoread

" Aucun son ou affichage lors des erreurs
set errorbells 
set novisualbell
set t_vb=

" Quand une fermeture de parenthèse est entrée par l'utilisateur,
" l'éditeur saute rapidement vers l'ouverture pour montrer où se
" trouve l'autre parenthèse. Cette fonction active aussi un petit
" beep quand une erreur se trouve dans la syntaxe.
set showmatch
set matchtime=2

" Afficher la barre d'état
set laststatus=2

" }}}2

" Options de recherche {{{2 

" Tout ce qui concerne la recherche. Incrémentale
" avec un highlight. Elle prend en compte la
" différence entre majuscule/minuscule.
set incsearch
set noignorecase
set infercase

set tags=$HOME/.vim/tags/tags,tags

set completeopt=menu,longest,preview

" Quand la rechercher atteint la fin du fichier, pas
" la peine de la refaire depuis le début du fichier
set hlsearch

" }}}2

" Options d'affichage texte {{{2

" On veut la numérotation de lignes
set nu
highlight LineNr ctermfg=grey

" Ne pas nous afficher un message quand on enregistre un readonly
set writeany

" Afficher les commandes incomplètes
set showcmd

" Afficher la position du curseur
set ruler
set cursorline

" Désactiver le wrapping
" set nowrap

" Options folding
"set foldmethod=marker

" Un petit menu qui permet d'afficher la liste des éléments
" filtrés avec un wildcard
set wildmenu
set wildignore=*.o,*#,*~,*.dll,*.so,*.a
set wildmode=longest,list

" Format the statusline
set statusline=%F%m\ %r\ Line:%l\/%L,%c%V\ %p%%

" Fix the difficult-to-read default setting for diff text highlighting.  The
" bang (!) is required since we are overwriting the DiffText setting. The
" highlighting
" for "Todo" also looks nice (yellow) if you don't like the "MatchParen"
" colors.
highlight! link DiffText MatchParen

" }}}2

" Options d'affichage GUI {{{2

" Configuration de la souris en mode console
" ="" pas de souris par défaut
"set mouse=vi
set mouse=n

" Améliore l'affichage en disant à vim que nous utilisons un terminal rapide
set ttyfast

" Lazy redraw permet de ne pas mettre à jour l'écran
" quand un script vim est entrain de faire une opération
set lazyredraw

if has("gui_running")
    map <S-Insert> <MiddleMouse>
    map <S-Insert> <MiddleMouse>

    set mousehide " On cache la souris en mode gui
    set ch=2 " ligne de commande dans deux ligne
endif

" colore la 80e colonne
set colorcolumn=80
highlight ColorColumn ctermbg=7

" }}}2

" Noms des fichiers {{{2

" faire en sorte que le raccourci CTRL-X-F
" marche même quand le fichier est après
" le caractère égal. Comme : 
" variable=/etc/<C-XF>
set isfname-==

" }}}2

" }}}1

" Autocmd {{{1

set cindent
"set autoindent
"set smartindent

if has("autocmd")
    " Détection auto du format
    " + activer indent
    filetype plugin indent on

    augroup divers " {{{2
        au!
        " Textwidth de 78 pour tous les fichiers texte
        "autocmd FileType text setlocal textwidth=78
        
        " Remet la position du curseur comme elle était avant
        autocmd BufReadPost *
        \ if line("'\"") > 0 && line("'\"") <= line("$") |
        \   exe "normal g`\"" |
        \ endif

        " La valeur des tabs par défaut
        " autocmd BufNewFile,BufRead * call ChangeTabSize(4, 0)

        " Ne pas faire de wrap dans les fichiers ChangeLog
        " autocmd BufNewFile,BufRead ChangeLog set nowrap textwidth=0
        " autocmd BufNewFile,BufRead ChangeLog call ChangeTabSize(8, 0)

        " PKGBUILD
        autocmd BufNewFile,BufRead PKGBUILD set syntax=sh
    augroup END " }}}2

    augroup pdf " {{{2
        au!
        autocmd BufReadPre *.pdf set ro
        autocmd BufReadPost *.pdf %!pdftotext -nopgbrk "%" - | fmt -csw78
    augroup END " }}}2
endif

" Pour les messages de commit git, limiter les lignes à 70 chars
" my filetype file
"if exists("did_load_filetypes")
"  finish
"endif
"augroup git
"  au! BufRead,BufNewFile COMMIT_MESSAGE		setfiletype git_commit
"augroup END

" }}}1

" Fonctions {{{1

" Fonctions utilisée par vimrc {{{2

"function! ChangeTabSize(tab_size, expandtab)
"    execute("set tabstop=".a:tab_size." softtabstop=".a:tab_size." shiftwidth=".a:tab_size)
"
"    if a:expandtab != 0
"        execute("set expandtab")
"    else
"        execute("set noexpandtab")
"    endif
"endfunction

" }}}2

" Les fonctions utiles pour l'utilisateur {{{2

" Aller dans le répertoire du fichier édité. {{{3

function! ChangeToFileDirectory()
    if bufname("") !~ "^ftp://" " C'est impératif d'avoir un fichier local !
        lcd %:p:h
    endif
endfunction

map ,fd :call ChangeToFileDirectory()<CR>

"}}}3

" Entrer la commande ":e" dans le répertiore du fichier édité {{{3

if has("unix")
    map ,e :e <C-R>=expand("%:p:h") . "/" <CR>
else
    map ,e :e <C-R>=expand("%:p:h") . "\" <CR>
endif

"}}}3

" Find file in current directory and edit it. {{{3
function! Find(...)
    let FindIgnore=['.swp', '.pyc', '.class', '.git', '.svn']
    if a:0==2
        let path=a:1
        let query=expand(a:2)
    else
        let path="./"
        let query=expand(a:1)
    endif

    if !exists("FindIgnore")
        let ignore = ""
    else
        let ignore = " | egrep -v '".join(FindIgnore, "|")."'"
    endif

    let l:list=system("find ".path." -type f -iname '*".query."*'".ignore)
    let l:num=strlen(substitute(l:list, "[^\n]", "", "g"))

    if l:num < 1
        echo "'".query."' not found"
        return
    endif
    
    if l:num == 1
        exe "open " . substitute(l:list, "\n", "", "g")
    else
        let tmpfile = tempname()
        exe "redir! > " . tmpfile
        silent echon l:list
        redir END
        let old_efm = &efm
        set efm=%f

        if exists(":cgetfile")
            execute "silent! cgetfile " . tmpfile
        else
            execute "silent! cfile " . tmpfile
        endif

        let &efm = old_efm

        " Open the quickfix window below the current window
        botright copen

        call delete(tmpfile)
    endif
endfunction

command! -nargs=* Find :call Find(<f-args>)

"}}}3

" Highlight all instances of word under cursor, when idle. {{{3
" Useful when studying strange source code.
" Type z/ to toggle highlighting on/off.
nnoremap z/ :if AutoHighlightToggle()<Bar>set hls<Bar>endif<CR>
function! AutoHighlightToggle()
  let @/ = ''
  if exists('#auto_highlight')
    au! auto_highlight
    augroup! auto_highlight
    setl updatetime=4000
    echo 'Highlight current word: off'
    return 0
  else
    augroup auto_highlight
      au!
      au CursorHold * let @/ = '\V\<'.escape(expand('<cword>'), '\').'\>'
    augroup end
    setl updatetime=700
    echo 'Highlight current word: ON'
    return 1
  endif
endfunction

" }}}3

" See diff between the currently edited file and its unmodified version {{{3

function! s:DiffWithSaved()
  let filetype=&ft
  diffthis
  vnew | r # | normal! 1Gdd
  diffthis
  exe "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
endfunction
com! DiffSaved call s:DiffWithSaved()

" }}}3

" }}}2

" }}}1

" Raccourcis clavier {{{1

" Vim 7 spell checker
if has("spell")
    setlocal spell spelllang=
    " Language : FR
    map ,lf :setlocal spell spelllang=fr<cr>
    " Language : EN
    map ,le :setlocal spell spelllang=en<cr>
    " Language : Aucun
    map ,ln :setlocal spell spelllang=<cr>
endif

set spellsuggest=5
autocmd BufEnter *.txt set spell
autocmd BufEnter *.txt set spelllang=fr

" Tabs
map ,t :tabnew<cr>
map ,w :tabclose<cr>
imap <C-t> <Esc><C-t>
imap <C-w> <Esc><C-w>
map <tab> gt
map <S-tab> gT

" Cacher le menu
map ,m :set guioptions=+M<cr>

" Mode normal
map ,mn :set guifont=<cr>

" Mode programmation
map ,mp :set guifont=Monospace\ 9<cr>

" Sélectionner tout
map <C-a> ggVG

" Copier (le gv c'est pour remettre le sélection)
map <C-c> "+ygv

" Couper
map <C-x> "+x

" Coller
map <C-p> "+gP

" Deplacer la sélection vers le haut/le bas
map <C-Up> :m .-2<cr>
map <C-Down> :m .+1<cr>
imap <C-Up> <C-o>:m .-2<cr>
imap <C-Down> <C-o>:m .+1<cr>
vmap <C-Up> :m '<-2<cr>'<V'>
vmap <C-Down> :m '>+1<cr>'<V'>

" Désactiver le highlight (lors d'une recherche par exemple)
map <F3> :let @/=""<cr>
map <C-F3> :call setqflist([])
nnoremap <silent> <F8> :TlistToggle<CR>

" Convertir un html
map ,h :runtime syntax/2html.vim<cr>

" encoder rapidement
map ,c ggVGg?

" }}}1

" Les plugins Vim et leurs options {{{1

" Gérer les fichiers man
runtime ftplugin/man.vim 

" }}}1

" Commandes {{{1

" grep dans le buffer et cree une list interactive
command! -nargs=1 Grep silent execute "grep -He ".<f-args>." % " | redraw! | cw
"command! -nargs=1 Grep g/<f-args>/p | redraw! | cw



" Commandes CScope
" ^_ is the global "CScope command".
" in normal mode, ^_^_ puts ":cscope find" in the cmdline
" ^_^w is same, but with :scscope (mnemonic: "Window")
" ^_^v is same as ^_^w, but with :vert
" in cmdline mode, ^_ puts the word under the cursor
nmap <cscope> :cs find<Space>
nmap <scscope> :scs find<Space>
nmap <vscscope> :vert scs find<Space>
cmap <cscope_ending> <Space><C-R>=expand("<cword>")<CR>

nmap <C-_><C-_> <cscope>
nmap <C-_><C-W> <scscope>
nmap <C-_><C-V> <vscscope>

cmap <C-_> <cscope_ending>

"nmap <C-_>s :cs find s <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"nmap <C-_>g :cs find g <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"nmap <C-_>c :cs find c <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"nmap <C-_>t :cs find t <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"nmap <C-_>e :cs find e <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"nmap <C-_>f :cs find f <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"nmap <C-_>i :cs find i ^<C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR>$<CR>
"nmap <C-_>d :cs find d <C-R>=substitute(substitute(expand(@/), "<", "", ""), ">", "", "")<CR><CR>
"
"nmap <C-Space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-Space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space>d :scs find d <C-R>=expand("<cword>")<CR><CR>
"
"nmap <C-Space>S :vert scs find s <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>G :vert scs find g <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>C :vert scs find c <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>T :vert scs find t <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>E :vert scs find e <C-R>=expand("<cword>")<CR><CR>
"nmap <C-Space>F :vert scs find f <C-R>=expand("<cfile>")<CR><CR>
"nmap <C-Space>I :vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"nmap <C-Space>D :vert scs find d <C-R>=expand("<cword>")<CR><CR>

map <F9> :TlistToggle<CR>

" }}}1

filetype plugin on
filetype indent on

set exrc

" brouillon {{{1
"
" "TODO: define it as a command instead of a function
" "exemple: com -nargs=+ Man call s:GetPage(<f-args>)
" function! ManWindow(...)
"     "if empty(v:servername)
"     "    let g:manserver = getpid() . "_man"
"     "else
"     "    let g:manserver = v:servername . "_man"
"     "endif
"     let g:manserver = "GVIM_MAN"
" 
"     let l:env = ""
"     "if !empty(a:sections)
"     "    let l:env .= "MANSECT=" . a:sections
"     "endif
" 
"     if !empty(l:env)
"         let l:env .= " "
"     endif
"     call system(l:env . "gvim --servername " . "GVIM_MAN" . "")
"     
"     "TODO: trouver une maniÃ¨re fiable de détecter the gvim est lancé
"     "(serverlist() peut-ètre ?)
"     sleep 2
"     call remote_send(g:manserver, ":Man printf<CR>:only<CR>")
" 
" endfunction
" command! -nargs=* ManWindow execute ManWindow(<f-args>)
" 
" map <C-Space>k :exec remote_send("GVIM_MAN", ":Man " . expand("<cword>") . "\<CR\>")<CR>

" " Android make glue
" function! GetRepoProjectPath(makeFilename)
"     let l:tail_cwd=strpart(getcwd(), strridx(getcwd(), "/")+1)
"     let l:project_path=strpart(a:makeFilename, 0, stridx(a:makeFilename, tail_cwd) + strlen(tail_cwd))
" 
"     return l:project_path
" endfunction

" vim:ai:et:sw=4:ts=4:sts=4:tw=78:fenc=utf-8:foldmethod=marker

"}}}1

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

" => Turn persistent undo on
" means that you can undo even when you close a buffer/VIM
if filewritable($HOME. "/.vim/undo") == 2
    set undodir=~/.vim/undo
    set undofile
else
    if has("unix") || has("win32unix")
        call system("mkdir $HOME/.vim/undo -p")
		set undodir=$HOME/.vim/undo
		set undofile
    endif
endif

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
set noautoread

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

" Couleurs
"colorscheme nuvola
set t_Co=256

" On veut la numérotation de lignes
set nu
highlight LineNr ctermfg=grey

" Afficher les commandes incomplètes
set showcmd

" Afficher la position du curseur
set ruler
set cursorline

" Désactiver le wrapping
" set nowrap

" Options folding
set foldmethod=syntax

" Un petit menu qui permet d'afficher la liste des éléments
" filtrés avec un wildcard
set wildmenu
set wildignore=*.o,*#,*~,*.dll,*.so,*.a
set wildmode=longest,list

" Format the statusline
set statusline=%F%m:%l\ \/%L,%c%V\ %p%%

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
set colorcolumn=80,100
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

" }}}2

" Les fonctions utiles pour l'utilisateur {{{2

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
command! DiffSaved call s:DiffWithSaved()

" }}}3

" }}}2

" }}}1

" Raccourcis clavier {{{1

" set leader to ,
let mapleader=" "
let g:mapleader=" "

" Alias , (comma) to : (colon)
map , :

" Vim 7 spell checker
if has("spell")
	setlocal spell spelllang=
	" Language : FR
	map <leader>lf :setlocal spell spelllang=fr<cr>
	" Language : EN
	map <leader>le :setlocal spell spelllang=en<cr>
	" Language : Aucun
	map <leader>ln :setlocal spell spelllang=<cr>
endif

set spellsuggest=5

" Tabs
map <tab> gt
map <S-tab> gT

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

" }}}1

" Les plugins Vim et leurs options {{{1

" Load pathogen
execute pathogen#infect()

" }}}1

" Commandes {{{1

" grep dans le buffer et cree une list interactive
command! -nargs=1 Grep silent execute "grep -He ".<f-args>." % " | redraw! | cw

" }}}1

" Special option to edit this file
"" vim:fileencoding=utf-8:foldmethod=marker

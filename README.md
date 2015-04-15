vim_configuration
==================

My vim commands, fonctions, hotkeys and plugins.

Install
-------

### Full

    git clone https://github.com/mat-tso/vim_configuration.git ~/.vim/
    ln -s ~/.vim/vimrc ~/.vimrc
    ln -s ~/.vim/ctags ~/.ctags
    ln -s ~/.vim/tmux  ~/.tmux.conf
    vim +PlugUpdate +quit

### Minimal

    wget -O ~/.vimrc https://raw.githubusercontent.com/mat-tso/vim_configuration/master/vimrc
    vim +PlugDl +quit
    vim +PlugUpdate +quit

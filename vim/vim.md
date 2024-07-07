# vim cheatsheet
### Find and replace:
This command will replace "foo" with "bar" in whole file
```
:%s/foo/bar/g
```

### Comments multiple lines:
First, press `ESC`
Go to the line from which you want to start commenting. Then, press `ctrl + v`, this will enable the visual block mode.
use the down arrow to select multiple lines that you want to comment.
Now, press `SHIFT + I` to enable insert mode.
Press `#` and it will add a comment to the first line. Then press `ECS` and wait for a second, # will be added to all the lines.

### Uncomments multiple lines:
- Press `CTRL + V` to enable visual block mode.
- Move down and select the lines till you want to uncomment.
- press `x` and it will uncomment all the selected lines at once.

### Settings for indentation for Yaml files:
vim /etc/vim/vimrc.local
autocmd FileType yaml setlocal ts=2 sts=2 sw=2 expandtab

### Install vim plugin:
```
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```
Then you can edit `~/.vimrc` like this:
```
call plug#begin('~/.vim/plugged')
Plug 'https://github.com/plugin1'
Plug 'https://github.com/plugin2'
call plug#end()
```
Finally install plugins:
```
:PlugInstall
```

### Write a read only file:
```
:w !sudo tee %
```
For more information: https://github.com/junegunn/vim-plug

###  Press `D` to delete characters from cursor to the end of line




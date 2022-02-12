# TMux cheatsheet 
### Terminal commands:
#### Kill a tmux session:
```
tmux kill-session -t ostechnix
```
#### A news session with the name 'name'
```
tmux new -s name
```
#### Rename a pane:
```
tmux rename-window -t number newname
```

### In TMux press ctrl+b+ one of these characters:

| ctrl+b+...       | Description                         |
| ---------------- |:-----------------------------------|
| %                 | Vertical split |
| "                 | Horizontal split |
| ⬆                | Move to top window |
| ⬇                | Move to bottom window  |
| ⬅                | Move to left window  |
| ➡                | Move to right window  |
| z                 | Zoom in/Zoom out  |
| c                 | Create a new tab   |
| $                 | Rename current session  |
| ,                 | Rename current tab  |
| 0..9                 | Switch between tabs  |
| w                 | Switch between tabs (choose)  |
| &                 | kill current window  |


### Enable fish inside Tmux:
```
set-option -g default-shell /usr/bin/fish
```
to make fish permanently active add followings to `~/.tmux.conf`:
```
set -g default-command /usr/bin/fish/
set -g default-shell /usr/bin/fish/
```

### Enable synchronize panes:
```
:set synchronize-panes
```
### Disable synchronize panes:
```
:set synchronize-panes off
```
### Assign ctrl+s to command synchronize-panes:
```
bind -n C-s set-window-option <synchronize-panes>
```



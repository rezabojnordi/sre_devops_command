# How To Find Largest Top 10 Files and Directories On Linux / UNIX / BSD

## Find the largest file in a directory and its subdirectories using the find command
``` 
# works in the current dir #
for i in G M K
do 
  du -ah | grep [0-9]$i | sort -nr -k 1
done | head -n 11

```

### Find the largest file in a directory and its subdirectories using the find command

```
## Warning: only works with GNU find ##
find /path/to/dir/ -printf '%s %p\n'| sort -nr | head -10
find . -printf '%s %p\n'| sort -nr | head -10
```

### Hunt down disk space hogs with ducks

```
## shell alias ##  
alias ducks='du -cks * | sort -rn | head'
## deal with special files names ##
alias ducks='du -cks -- * | sort -rn | head'

```

## Summing up

```
man du
man sort
man head
man find
```


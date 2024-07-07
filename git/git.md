# Git cheatsheet 

### Store credential:
`git config --global credential.helper store`

### Clone from a specific branch:
`git clone -b branch repo`

### Add files to git:
`git add file`

### Commit files:
`git commit -am "Message"`

### Push commits to repo:
`git push`

### Pull commits from repo:
`git pull`

### Change to another branch:
`git checkout branch`

### Merge dev into master:
```commandline
git checkout master
git merge dev
```

### How to clear commit history for main branch:
```commandline
git checkout --orphan latest_branch
git add -A
git commit -am "commit message"
git branch -D main
git branch -m main
git push -f origin main
```

### Shows wether remote and origin synced :
```commandline
git remote show origin
```
### To sync data between remote and local:
```commandline
git fetch
```

### Shows the log in form of graph one line percommit:
```commandline
git log --graph --oneline --all
```
### To delete a remote branch:
```commandline
git push --delete origin branch_name
```
### To delete a local branch:
```commandline
git branch -d branch_name
```
### To change the latest commit message:
```commandline
git commit --amend -m "New commit message."
```
### To close an issue in a commit use `Closes #1` in commit message. 1 is issue number



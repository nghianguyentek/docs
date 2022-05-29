# Git
## Clone repository
`git clone repository_uri`
## Branch
### Check the current branch name
`git branch`
### Create a new branch
`git branch new_branch_name`
## Pulling codes
### Get changes of the current branch from the repository to local  
`git pull`
## Commit changes
### Check changes status (e.g., ready to commit and unknown)
`git status`
### See changes made in a file
`git diff file_path`
### Revert changes made in a file
`git checkout -- file_path`
### Mark changes is ready to commit
```
# Add one file
git add file_path
# Add multiple files (separated by a space between two)
git add file_path_1 file_path_2
```
### Commit your changes
`git commit -m "Commit description here"`
## Merging
### Merge code from another branch to the current branch
```shell
# Move your changes to the stash
git stash
# Merge code from another branch to the current one
# For example, git merge origin/master
git merge branch_name
# Pop your changes back
git stash pop
# if having conflicts, open mergetool
git mergetool
```
### Move changes from one branch to another one
```shell
# Move your changes to the stash
git stash
# Change to another branch
git checkout branch_name
# Pop your changes back
git stash pop
```
## Pushing
### Pushing commits back to repository
`git push`
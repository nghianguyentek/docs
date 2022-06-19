# macOS
- [Create a link (shortcut)](#create-a-link-shortcut)
## Create a link (shortcut)
```shell
ln -s destination location
```
where:
- destination is the absolute path of the target directory or file.
- location is the directory where we place the created link.
### Examples
- Create a link to a specific folder
```shell
# Create a link to kihon.vn directory at the current user home directory
ln -s ~/Documents/GitHub/kihon.vn ~
# Go to the kihon.vn directory
cd ~/kihon.vn
```
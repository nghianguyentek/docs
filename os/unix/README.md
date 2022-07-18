# UNIX
## Filesystem
### bin
*The `bin` directory contains common utilities.*
### sbin
*The `sbin` directory contains system super-user utilities.*
- [sysctl](#sysctl): get/set kernel state.
### usr
*The `usr` directory contains all user utilities.*
#### usr/bin
*The `usr/bin` directory contains user common utilities.*
- [grep](#grep): search text in files using Regular Expression.
## grep
*An user common utility to search text in files using Regular Expression.*
```shell
# Search with or condition '\|'
sysctl -a | grep 'backlog\|somaxconn'
```
## sysctl
*An system super-user utility to get/set kernel state.*
```shell
# Display all kernel states
sysctl -a
```
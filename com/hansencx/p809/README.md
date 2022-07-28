# P809
## Dev environment
*Pvm was obsoleted, so we need to use Remote Desktop (to a VCN-Virtual Computing Network) instead.*
1. From Dvm, login to dev machine 
```shell
ssh asu-sparqp1dev
```
2. Start a session
```shell
vncserver :X-display -depth 24 -geometry 1920x1080
```
where:
- `X-display`: a positive integer.
3. Get the server listening port
Open the log file and grep the server listening port.
```shell
grep port /home/peace/nghia.nguyen/.vnc/asu-sparqp1dev.nz.hsntech.int:3.log
```
4. Open VNC viewer and connect to the server listening port
5. Kill a session
```shell
vncserver -kill :X-display
```
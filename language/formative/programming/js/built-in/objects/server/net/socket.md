# Socket
## Events
### data
```
socket.on('data', data => {});
```
where
- data: `Buffer | String`
### close
```
socket.on('close', hadError => {});
```
where
- hadError: `true | false` indicates transmission error occurred or not.
## Methods
### end
Close the socket.
```
socket.end();
```
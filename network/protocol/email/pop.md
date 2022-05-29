# POP (Post Office Protocol)
## Characteristics
- A line-based protocol.
- Listening port: `110`.
## Phrases
- Authorisation
- Transaction
- Update
## Messages
### Sending username
#### Request
`USER username`
#### Reply
- `+OK`
- `-ERR`
### Sending password
#### Request
`PASS password`
#### Reply
- `+OK`
- `-ERR`
### Checking if having emails or not
#### Request
`STAT`
#### Reply
- `+OK noOfMessages totalSizeInBytes`
- `-ERR`
### Listing size of emails
#### Request
`LIST`
#### Reply
```
+OK
1 sizeOf1#EmailInBytes
...
n sizeOfN#EmailInBytes
```
### Retrieving an email by its number
#### Request
`RETR messageNo`
#### Reply
- `+OK`
- `-ERR`
### Mark to delete an email by its number when the current session ends
#### Request
`DELE messageNo`
#### Reply
- `+OK`
- `-ERR`
### End the current session
#### Request
`QUIT`
#### Reply
- `+OK`
- `-ERR`
## References
[Myers, J., Mellon, C., & Rose, M. (1996). *Post Office Protocol - Version 3*. Network Working Group.](https://datatracker.ietf.org/doc/html/rfc1939)
# TCP (Transmission Control Protocol)
One of two well-known transport protocols of the IP suite.
## Characteristics
- Connection-Oriented
- Stream-Oriented: responds to buffer and/or divide data into appropriate sized packets.
- Numbered
- Timeout & retransmission control.
## Header
Without options, a TCP header occupies 20 bytes.
- Source Port: 16 bits.
- Destination Port: 16 bits.
- Sequence Number: 32 bits.
- Acknowledgement Number: 32 bits.
- Data Offset: 4 bits.
- Reserved: 4 bits.
- CWR: 1 bit.
- ECE: 1 bit.
- URGgent: 1 bit.
- ACKnowledgement: 1 bit.
- PuSH: 1 bit.
- ReSeT: 1 bit.
- SYNchronize: 1 bit.
- FINish: 1 bit.
- Window Size: 16 bits.
- Checksum: 16 bits.
- Urgent Pointer: 16 bits.
- Options and Padding: 32 bits.
## State
- `CLOSED`
- `LISTEN` (Server only)
- `SYN_SENT` (Client only)
- `SYN_RECEIVED` (Server only)
- `ESTABLISHED`
- `FIN_WAIT_1` (Active Close)
- `FIN_WAIT_2` (Active Close)
- `CLOSING` (Active Close)
- `TIME_WAIT` (Active Close)
- `CLOSE_WAIT` (Passive Close)
- `LAST_ACK` (Passive Close)
### ESTABLISHED
##### Half-Open
A situation when one-side reboots in an established connection.
### FIN_WAIT
##### FIN_WAIT_1
After sending the `FIN` packet, the state changes from `ESTABLISHED` to `FIN_WAIT_1`.
##### FIN_WAIT_2
After receiving the `ACK of FIN` packet, the state changes from `FIN_WAIT_1` to `FIN_WAIT_2`.
##### Half-Closed 
Node's state is in FIN_WAIT.
### TIME_WAIT
Change to `CLOSED` after 2xMSL(Maximum Segment Lifetime, is often 30 seconds).
- Solving external old-duplicate problem.
- Lost final `ACK`.
## TCP options
- Delayed ACKs
- Delayed sending data
- Keep alive
### Delayed ACKs
`TCP_QUICKACK` option is used to disable delayed ACK on a specific connection and will be reset after next TCP system call
(i.e., should be set after each receiving).
### Delayed sending data
`TCP_NODELAY` option is used to disable Nagle's algorithm on a specific connection.
#### Nagle's algorithm
Delay sending small packets.
### Keep alive
Periodically, both sides check the status of each other, by sending data-less packets, until exceeding the limit, 2 hours by default.  
`TCP_KEEPALIVE`
## CLI commands
### Checking a port is listening on a remote host
`nc -vz host port`  
`telnet host port`  
`curl telnet://host:port`
## References
- [Dordal, P. L. (2019). *An Introduction to Computer Networks. Loyola University Chicago.](http://intronetworks.luc.edu)
# TCP (Transmission Control Protocol)
<pre>
One of two well-known transport protocols of the IP suite.
</pre>
## Characteristics
- Connection-Oriented
- Stream-Oriented
- Numbered
- Timeout & retransmission control.
## Header
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
- CLOSED
- LISTEN (Server only)
- SYN_SENT (Client only)
- SYN_RECEIVED (Server only)
- ESTABLISHED
- FIN_WAIT_1 (Active Close)
- FIN_WAIT_2 (Active Close)
- CLOSING (Active Close)
- TIME_WAIT (Active Close)
- CLOSE_WAIT (Passive Close)
- LAST_ACK (Passive Close)
#### TIME_WAIT
Change to CLOSED after 2xMSL(Maximum Segment Lifetime, is often 30 seconds).
- Solving external old-duplicate problem.
- Lost final ACK.
## References
- [Dordal, P. L. (2019). *An Introduction to Computer Networks. Loyola University Chicago.](http://intronetworks.luc.edu)
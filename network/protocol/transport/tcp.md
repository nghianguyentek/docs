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
## References
- [Dordal, P. L. (2019). *An Introduction to Computer Networks. Loyola University Chicago.](http://intronetworks.luc.edu)
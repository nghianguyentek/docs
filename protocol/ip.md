# Internet Protocol
> Connectionless: send and hope it to be there.  

> A virtual LAN overlays all physical LANs.
## Terms
### IP address
An IP address contains two parts, network and host. Currently, IP address has two versions, IPv4 and IPv6.
#### IPv4 (RFCs 791, 1122, 2474, and 2481)
One IPv4 address has 32 bits in size.
##### IPv4 header
One IPv4 header contains 5-octet basic words and 10-octet optional words.

1. 1st word
   - Version: 4 bits.
   - IP Header Length (IHL): 4 bits.
   - Differentiated Services (DS): 6 bits.
   - Explicit Congestion Notification (ECN): 2 bits.
   - Total Length: 16 bits.
2. 2nd word
   - Identification: 16 bits.
   - Flags: 3 bits.
   - Fragment Offset: 13 bits.
3. 3rd word
   - Time To Live (TTL): 8 bits.
   - Protocol: 8 bits.
   - Checksum: 16 bits.
4. 4th word
   - Source address: 32 bits.
5. 5th word
   - Destination address: 32 words
6. 6th-10th words
   - IPv4 Options: 24 bits.
   - Padding: 8 bits.

#### IPv6

### Loopback address
> 
IPv4: 127.0.0.1
IPv6: ::1
### Private address

IPv4:
- 10.0.0.0/8
- 172.16.0.0/12
- 192.168.0.0/16

IPv6:
- ::1


## Problems
### Overflowing router queue
## References
Dordal, P. L. (2019). *An Introduction to Computer Networks*. Loyola University Chicago.

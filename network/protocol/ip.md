# Internet Protocol
Connectionless: send and hope it to be there (i.e., no acknowledgement and retransmission).  
A virtual LAN overlays all physical LANs.
## Address
An IP address contains two parts, network and host (for <a href="ipv4.md">IPv4</a> and interface identifier for <a href="ipv6.md">IPv6</a>). 
Currently, IP address has two versions, <a href="ipv4.md">IPv4</a> and <a href="ipv6.md">IPv6</a>.
## Fragmentation
Fragmentation is a feature to split size-exceeded packets into smaller supported ones.
## Routing algorithms
### Interior algorithms
#### Distance vector routing
While exchanging information with their direct neighbours, routers build their forwarding tables periodically using 
[RIP (Routing Information Protocol)](routing/rip.md) or its enhanced version, <a href="eigrp.md">EIGRP (Enhanced Interior Gateway Routing Protocol</a>. Usually, 
small sites use this algorithm.
#### Loop-free distance vector
##### Destination-sequenced distance vector (DSDV)
- Destination
- Cost
- Next-hop
- **Sequence number**
##### Ad-hoc On-demand Distance Vector (AODV)
#### Link state routing
In this model, very router notifies its known link states to all others and each node keeps routing information as much 
as possible.
## Problems
### Overflowing router queue
## References
[Dordal, P. L. (2019). *An Introduction to Computer Networks*. Loyola University Chicago.](http://intronetworks.cs.luc.edu/)

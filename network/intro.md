# Introduction
## Transmission types
- Broadcast: sends data to all nodes in a network.
- Unicast: sends data to a specific node in a network.
## Design a network protocol or set up a network
### Criteria
- Transmission
- Geographical area
- Technology
- User group
- Application
## Network categories
### By transmission
- Connection-oriented
- Connectionless
### By size
- [LAN (Local Area Network)](lan.md)
- MAN (Metropolitan Area Network)
- WAN (Wide Area Network)
- Internet
## Terms
### Bandwidth
[Data rate](#data-rate) (more common) or [throughput](#throughput).
### Data rate
The data transmission rate in bits per second (`bps`) and can vary in time.

*Note that (the lower-case) `b` stands for `bit` meanwhile (the upper-case) `B` stands for `byte`.*
### Throughput
The overall data rate  
##### RTT (Round-Trip-Time)
<pre>
A duration between sending a packet and receiving its response.
</pre>
##### winsize (window size)
<pre>
The number of packets that a sender can send before waiting for an ACK.
</pre>
##### BDP (Bandwidth x Delay Product)
<pre>
BDP, Bandwidth x <a href="#RTT-(Round-Trip-Time)">RTT</a>, represents the amount of data can be sent before receiving the first response.
Generally, it's an optimum value for a <a href="#winsize-(window-size)">winsize</a>.
</pre>
##### Network path
##### Path bandwidth
<pre>
The minimum bandwidth in a network.
</pre>
### Protocol
A set of rules.
### Router
Responsibilities:
- Routing
- Decrease TTL
- Attach new LAN header
- Update header checksum
- Serve as a firewall (optional)
### Switch
Responsibilities:
- Routing
### NAT (Network Address Translation)
<pre>📖 A solution enables routing to multiple hosts behind one (or a few) IPv4 addresses.</pre>
<pre>⚠️ Connection from outside to internal hosts through a NAT router is forbidden. 
(except VPN connections & static NAT entries)</pre>
<pre>📚 <a href="https://datatracker.ietf.org/doc/html/rfc3022.html" target="_blank">RFC 3022</a></pre>

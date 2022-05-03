# Neighbour Discovery for IPv6 (ND)
<pre>📖 ND is a protocol for IPv6 same-link nodes to discover each other (including routers) about presence, address,
and reaching path. Indeed, it a combination (with improvements and extensions) of existing protocols such as 
<a href="arp.md">Address Resolution Protocal (ARP)</a> and Internet Control Message Protocol (ICMP).</pre>
## Router discovery
### Ways
#### Pushing by routers
```mermaid
sequenceDiagram
participant IPv6 routers
participant Nodes in multicast group
IPv6 routers ->> Nodes in multicast group: (periodically) publish Router Advertisement (RA) packets
```
#### Actively requesting
```mermaid
sequenceDiagram
participant IPv6 node
participant Routers in multicast group
IPv6 node ->> Routers in multicast group: send Router Solicitation request
```
### Messages
#### Router Advertisement
```
📖 A Router Advertisement message contains:
- Router information
- All network prefixes in LAN
- MTU information (optional)
```
#### Router Solicitation
## Neighbour discovery
### Ways
#### Actively periodical requesting
```mermaid
sequenceDiagram
participant Node
participant Solicited node
Node ->> Solicited node: (periodically) publish Neighbour Solicitation message
Solicited node -->> Node: Neighbour Advertisement message
```
#### Pushing by unsolicited node
*For quickly changes notification*
```mermaid
sequenceDiagram
participant Unsolicited node
participant Neighbour node
Unsolicited node ->> Neighbour node: publish Neighbour Advertisement message
```
### Messages
#### Neighbour Solicitation
#### Neighbour Advertisement
## References
- [Narten, T., Nordmark, E., Simpson, W., & Soliman, H. (2007). *Neighbor Discovery for IP version 6 (IPv6)*. Network Working Group.](https://datatracker.ietf.org/doc/html/rfc4861.html)

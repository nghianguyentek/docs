# Neighbour Discovery for IPv6 (ND)
```
📖 ND is a protocol for IPv6 nodes in the same link to discover each other (including routers) about
presence, address, and reaching path.
```
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
- [RFC 4861 - Neighbour Discovery for IPv6](https://datatracker.ietf.org/doc/html/rfc4861.html)
- [RFC 8504 - IPv6 Node Requirements](https://datatracker.ietf.org/doc/html/rfc8504)

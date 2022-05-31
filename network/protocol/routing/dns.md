# DNS (Domain Name System)
*DNS is an essential companion for the IP (Internet Protocol) suite since it responds to resolving a domain name (a hierarchical name) to an IP address (the reversal way is optional). DNS often runs on top of [UDP (User Datagram Protocol)](../transport/udp.md) for small and fast query responses and on top of [TCP (Transmission Control Protocol)](../transport/tcp.md) for enormous query responses.*
## The hierarchical naming scheme
## Nameserver
## DNS resolver
## DNS message
### DNS header
*A DNS header occupies 12 bytes*

| No  | Name    | Description                                  | No of bits |
|-----|---------|----------------------------------------------|------------|
| 1   | ID      |                                              | 16         |
| 2   | QR      | Query or Response                            | 1          |
| 3   | Opcode  | Query type                                   | 4          |
| 4   | AA      | Authoritative Answer (Is server authorised?) | 1          |
| 5   | TC      | TrunCation (Is message truncated?)           | 1          |
| 6   | RD      | Recursive Desired                            | 1          |
| 7   | RA      | Recursive Available                          | 1          |
| 8   | Z       | Reserved for future uses                     | 3          |
| 9   | RCODE   | Response code                                | 4          |
| 10  | QDCOUNT | Queries Count                                | 16         |
| 11  | ANCOUNT | Answers Count                                | 16         |
| 12  | NSCOUNT | NameServers Count                            | 16         |
| 13  | ARCOUNT | Additional Records Count                     | 16         |
#### Response codes
| Code   | Description                              |
|--------|------------------------------------------|
| 0b0000 | No error                                 |
| 0b0001 | Format error                             |
| 0b0010 | NameServer failure                       |
| 0b0011 | Name error (Data not found)              |
| 0b0100 | Not implemented (Unsupported query type) |
| 0b0101 | Refused                                  |


### DNS resource record
## References
[Mockapetris, P. (1987). *DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION*. Network Working Group.](https://datatracker.ietf.org/doc/html/rfc1035.html)
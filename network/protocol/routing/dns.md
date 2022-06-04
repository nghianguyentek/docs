# DNS (Domain Name System)
*DNS is an essential companion for the [IP (Internet Protocol)](../ip.md) suite since it responds to resolving a domain name to an IP address (the reversal way is optional). Since it can resolve a domain name to the corresponding IP address, the assigned IP becomes transparently from the user's view. DNS often runs on top of [UDP (User Datagram Protocol)](../transport/udp.md) for small and fast query responses and on top of [TCP (Transmission Control Protocol)](../transport/tcp.md) for enormous query responses.*
## The hierarchical naming scheme
*A domain name is a right-to-left and dot-separated hierarchy.*

For example, `google.com`; `com` is the top-level node, and `google` is the second-level one.
### Top-level domain names
#### Common
| Name | Description                                              | Example      |
|------|----------------------------------------------------------|--------------|
| com  | Company                                                  | google.com   |
| net  | Network                                                  |              |
| org  | General organisations                                    |              |
| int  | International organisations                              |              |
| edu  | Education organisations such as universities or colleges | uopeople.edu |
| mil  | Military                                                 |              |
| gov  | Government                                               |              |
#### Country
| Name | Country       |
|------|---------------|
| vn   | VietNam       |
| us   | United States |
|      |               |
|      |               |
#### Extensions
| Name | Description | Example   |
|------|-------------|-----------|
| io   |             | github.io |
|      |             |           |
|      |             |           |
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
- NS: name of the next zone to ask
- A or AAAA
- CNAME (Canonical name): create alias (e.g., `www.example.com` is a `CNAME` of `pc12.example.com`)
- ANAME 
## References
[Mockapetris, P. (1987). *DOMAIN NAMES - IMPLEMENTATION AND SPECIFICATION*. Network Working Group.](https://datatracker.ietf.org/doc/html/rfc1035.html)
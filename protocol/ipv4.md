# Internet Protocol version 4 (IPv4)
## Address
```
IPv4 address has 32-bit length and categorize to four classes:
- A: 0-127.*.*.*/8 for a few very large networks
- B: 128-191.*.*.*/16 for institute-sized networks
- C: 192-223.*.*.*/24 for smaller entities
- D: 224-239.*.*.*/4 for multicast
```
### Loopback
`127.0.0.1`
### Private
- `10.0.0.0/8`
- `172.16.0.0/12`
- `192.168.0.0/16`
### Broadcast
```
All host bits are one.
```
## Subnet
## Header
```
An IPv4 header includes a required section and optional section.
```
### Required section
The required section is 20-byte in size and contains the following fields in order:
- `Version`: 4 bits
- Internet Header Length (`IHL`): 4 bits
- `Type of service`: 8 bits
- `Total length`: 16 bits
- `Identification`: 16 bits
- `Flags`: 3 bits
- `Fragment offset`: 13 bits
- Time To Live (`TTL`): 8 bits
- `Protocol`: 8 bits
- `Header checksum`: 16 bits
- `Source address`: 32 bits
- `Destination address`: 32 bits.
#### Fragmentation
```
If the DF flag value of the size-exceeded packet is one, the router will drop it.
```
### Optional section
The optional section is from 4-byte to 40-byte in size and contains the following fields in order:
- `Options`
- `Padding`: to ensure the size of option section is a product of 4-bytes.

## References
- [Information Sciences Institute. (1981). *Internet Protocol*. University Southern California.](https://datatracker.ietf.org/doc/html/rfc791)


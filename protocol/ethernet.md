# Ethernet protocol
## Package format
In order,
- dest addr: 48 bits.
- src addr: 48 bits.
- type: 16 bits.
- data: 46-1500 bytes.
- CRC checksum: 32 bits.
### Common type values
- 0x0800: IP
- 0x8173: IPX
- 0x0806: [ARP](arp.md)

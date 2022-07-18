# Buffer
## Static
### Methods
#### from
```
const buf = Buffer.from(object[, encoding[, length]]);
```
where
- object: `string`, or `array`.
- [encoding](#encodings) 
## Instance
### Methods
#### toString
```
const str = buf.toString([encoding[, start[, end]]]);
```
where
- [encoding](#encodings)
- start: default `0`
- end: default `buf.length`
## Encodings
- `utf8` (default)
- `hex`
- `base64`
- `base64url`
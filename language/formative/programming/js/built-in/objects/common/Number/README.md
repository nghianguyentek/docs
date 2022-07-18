# Number built-in object
## Methods
### isInteger
```js
Number.isInteger(2017);
```
### parseInt
```js
Number.parseInt(str, radix);
```
where
- radix: `2`, `8`, `10`, and `16`.

Examples
```js
const input = '111';
const inputNumber10 = Number.parseInt(input, 10);  // 1*10*10 + 1*10 + 1 = 111
const inputNumber2 = Number.parseInt(input, 2);  // 1*2*2 + 1*2 + 1 = 7
const inputNumber8 = Number.parseInt(input, 8);  // 1*8*8 + 1*8 + 1 = 73
const inputNumber16 = Number.parseInt(input, 16);  // 1*16*16 + 1*16 + 1 = 273
```
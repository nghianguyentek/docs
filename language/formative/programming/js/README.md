# JS (JavaScript)
## Import external scripts
```html
<script src="js/main.js" defer></script>
```
## Literal
### String literal
```js
'h1'
'login'
```
### Numeric literal
```js
1
5
8.5
9007199254740993n
```
### Boolean literal
```js
true
false
```
### Object literal
```js
{}
[] // also array literal
null
```
### Undefined literal
```js
undefined
```
## Data types
*JavaScript is a loosely-typed and dynamic programming language.*
### Primitive
*Primitive data types are types not `object` and has no methods either properties.* 
- `string`: a sequence of characters.
- `number`: integer, floating-point numbers, and `NaN` (Not a Number).
- `boolean`: `true` or `false`
- `undefined`: `undefined`
- `null`: a special `object` that has no method nor properties.
- `bigint`: big integer (postfix `n`)
- `symbol`: managed-unique values for property-keys.
### Complex
- `Object` or `object`: a base type for all complex types and be considered as a collection of properties (somehow a hashmap/hash table/dictionary).
- `Array`: array objects.
- `Function`: an callable/executable `object`.
- `Date`: represents date time.
- `Set` and `WeakSet`: sets.
#### Primitive wrapper
- `String`: wrapper type for `string` primitive.
- `Number`: wrapper type for `number` primitive.
- `Boolean`: wrapper type for `boolean` primitive.
- `BigInt`: wrapper type for `bigint` primitive.
- `Symbol`: wrapper type for `symbol` primitive.

*`valueOf()` method of a primitive-wrapper returns the encapsulated primitive value.*
### typeof operator
We can use `typeof` operator to get type of variables.
```js
typeof 1  // number
typeof 1.5  // number
typeof true  // boolean
typeof 'true'  // string
typeof {}  // object
typeof []  // object
typeof null   // object
typeof undefined  // undefined
typeof 1n  // bigint
typeof Symbol.for('mysymbol')  // symbol
```

*There is a a strange (legacy bug/error) when applying `typeof` on a function, `'function'` returned instead of `'object'`.*
## Variable
### Declaration
```js
let header;
```
### Assignment
```js
header = document.querySelector('#header');
```
## instanceof operator
```js
1 instanceof Number
```
## Next steps

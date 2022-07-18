# Array
## Instance
### Properties
#### length
```js
array.length
```
Example
```js
const array = ['a', 'b', 'c', 'd'];
const arrayLength = array.length;  // 4
```
### Methods
#### push - Add one item to the end
```js
const newLength = array.push(newItem);
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
array.push('e');  // array = ['a', 'b', 'c', 'd', 'e']
```
#### unshift - Add one item to the beginning
```js
const newLength = array.unshift(newItem);
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
array.unshift('e');  // array = ['e', 'a', 'b', 'c', 'd']
```
#### pop - Remove the last item
```js
const lastItem = array.pop();
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const lastItem = array.pop();  // 'd'
```
#### shift - Remove the first item
```js
const firstItem = array.shift();
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const firstItem = array.shift();  // 'a'
```
#### forEach - Loop through
```
array.forEach(item => ...);
```
Example
```js
const array = ['a', 'c', 'b', 'c', 'd'];
array.forEach(item => console.log(item));
```
#### includes - Check if the array contains a value or not
```
boolean array.includes(value[, fromIndex]);
```
Example
```js
const array = ['a', 'b', 'c'];
const found1 = array.includes('a');  // found1 = true
const found2 = array.includes('a', 1);  // found2 = false
```
#### splice - Create a new array by removing a range of items
```js
const newArray = array.splice(inclusiveStartItemIndex, numberOfItems);
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const newArray = array.splice(1, 2);  // ['a', 'd']
```
#### slice - Create a new array which is a range of the original array
```js
const aRangeOfItems = array.slice(inclusiveStartItemIndex, exclusiveEndItemIndex);
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const newArray = array.slice(1, 3);  // ['b', 'c']
```
#### indexOf - Find the first item index that equals a specific value
*If not found, returns -1.*
```
const firstMatchedItemIndex = array.indefOf(itemValue[, fromForwardIndex]);
```
Examples
```js
const array = ['a', 'c', 'b', 'c', 'd'];
const firstMatchedItemIndex = array.indefOf('c');  // 1
```
```js
const array = ['a', 'c', 'b', 'c', 'd'];
const firstMatchedItemIndex = array.indefOf('c', 2);  // 3
```
#### findIndex - Find the first satisfying item index based on a predicate
*If not found, returns -1.*
```
const fistSatisfyingIndex = array.findIndex(item => true|false);
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const fistSatisfyingIndex = array.findIndex(item => item > 'b');  // 2
```
#### lastIndexOf - Find the last item index that equals a specific value
*If not found, returns -1.*
```
const lastFoundIndex = array.lastIndexOf(itemValue[, fromBackwardIndex]);
```
Examples
```js
const array = ['a', 'c', 'b', 'c', 'd'];
const lastFoundIndex = array.lastIndexOf('c');  // 3
```
```js
const array = ['a', 'c', 'b', 'c', 'd'];
const lastFoundIndex = array.lastIndexOf('c', 2);  // 1
```
#### findLastIndex - Find the last item index that satisfies a specific predicate
*If not found, returns -1.*
```
const foundIndex = array.findLastIndex(item => true|false);
```
#### map - Create a new array with a specific transformer
```js
const newArray = array.map(item => {});
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const newArray = array.map(item => item + 'x');  // ['ax', 'bx', 'cx', 'dx']
```
#### filter - Create a new array by filtering
```js
array.filter((item) => {});
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const newArray = array.filter(item => item > 'c');  // ['d']
```
#### reduce - Accumulate items
```
TResult array<T>.reduce((TResult, TCurrent) => ...[, TInitialResult])
```
Examples
```js
const array = ['a', 'b', 'c', 'd'];
const result = array.reduce((result, item) => result + item);  // abcd
const result = array.reduce((result, item) => result + item, 'x');  // xabcd
```
```js
const array = ['1', '2', '3', '4'];
const result = array.reduce((result, item) => result + item);  // 10
const result = array.reduce((result, item) => result + item, 100);  // 110
```
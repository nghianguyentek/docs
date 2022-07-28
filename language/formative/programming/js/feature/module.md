# Module
## Naming convention
`.mjs`
## export
```js
export { ... };
```
## import
### import keyword
```js
import { ... } from 'url';
```
where:
- `url`: where placing the module script
### import() function
```js
import('url')
    .then(module => ...);
```
### In HTML
```html
<script type="module" src="url"></script>
```

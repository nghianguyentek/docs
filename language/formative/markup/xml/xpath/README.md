# XPath
- XPath is a W3C recommendation for selecting parts in a DOM.
- Has more than 200 built-in functions.
## Selections
### Element name
Gets all elements whose name equals the given one.
#### Example
Selects all h1 elements.
```
h1
```
### From root element
Selects from the root element.
#### Example
Selects all h1 elements from root element.
```
/h1
```
### Current element
`.`
### Parent element
`..`
### Attribute
`@attributeName`
## Predicates
```
[predicate]
```
### Examples
Element whose has the specific index
```
[index]
```
First element
```
[first()]
```
Last element
```
[last()]
```
Elements #1 and #2
```
[position()<3]
```
Having a specific attribute
```
[@attributeName]
```
## Wildcards
- `*`: all elements
- `@*`: all attributes
- `node()`: any node
## Select multiple paths
To select multiple paths, we use the `|` (pipe sign).
### Example
Select all `book` and `author` elements.
```
//book | //author
```
## Axes
### Forward
- `child::`: all children nodes of the context node (equivalent `/nodeName`)
- `descendant::`: all descendant nodes of the context node.
- `attribute::`: all descendant elements of the context node having the specific attribute (equivalent `@attributeName`).
- `self::`: the context node (equivalent `.`).
- `descendant-or-self::`: the context node and its descendant nodes.
- `following-sibling::`: the next sibling node of the context node.
- `following::`: all next siblings nodes of the context node.
- `namepsace::`: all namespace nodes of the context node.
### Reverse
- `parent::`: the parent node of the context node.
- `ancestor::`: all ancestor nodes of the context node.
- `preceding-sibling::`: the previous sibling node of the context node.
- `preceding::`: all previous sibling nodes of the context node.
- `ancestor-or-self::`: the context node and all its ancestor nodes.
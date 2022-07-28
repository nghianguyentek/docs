# DOM (Document Object Model)
DOM is a W3C platform and language to manipulate markup documents.
## Node
- A base object in DOM that has properties and methods.
- An element is a node whose type is element.
- Every element and attribute has one parent element, except the root element.
- Siblings are nodes that have the same parent.
### Properties
- `readonly unsigned short nodeType`: one of [types](#node-types).
- `readonly string nodeName`: based on the node type, see [node name](#node-name).
- `readonly NodeList childNodes`
- `readonly Node? parentNode`
- `readonly Element? parentElement`
- `readonly Node? firstChild`
- `readonly Node? lastChild`
- `readonly Node? previousSibling`
- `readonly Node? nextSibling`
- `readonly string? nodeValue`
- `readonly string? textContent`
### Methods
- `boolean hasChildNodes()`
- `boolean contains(Node? otherNode)`
- `boolean isEqualNode(Node? otherNode)`
- `Node cloneNode(optional boolean includingChildren = false)`
- `Node insertBefore(Node targetChild, Node? newChild)`
- `Node appendChild(Node newChild)`
- `Node replaceChild(Node replacedChild, Node newChild)`
- `Node removeChild(Node removedChild)`
## Node types

| Value | Type                   |
|:-----:|------------------------|
|   1   | Element                |
|   2   | Attribute              |
|   3   | Text                   |
|   4   | CDATA section          |
|   7   | Processing instruction |
|   8   | Comment                |
|   9   | Document               |
|  10   | Document type          |
|  11   | Document fragment      |

## Node name

| Node type              | Name value                    |
|------------------------|-------------------------------|
| Element                | Uppercase tag/element name    |
| Attribute              | Attribute name                |
| CDATA section          | #cdata-section                |
| Processing instruction | Processing instruction target |
| Comment                | #comment                      |
| Document               | #document                     |
| Document type          | Document type name            |
| Document fragment      | #document-fragment            |

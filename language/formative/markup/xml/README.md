# XML (eXtensible Markup Language)
XML is a W3C-recommended standard to represent structured data in a human-readable format capable of storing and transferring between information systems. 
- [Characteristics](#characteristics)
- [Structure](#structure)
- [Namespaces](#namespaces)
- [Comment](#comment)
- [Well-formedness](#well-formedness)
- [Validness](#validness)
  - [Xml Schema](#xml-schema)
- [XML and JavaScript](#xml-and-javascript)
- [XPath](./xpath)
- [XSLT](./xslt)
## Characteristics
- A markup language.
- Human-readable.
- Structured and self-descriptive.
- Data concentrated (designed for storing and transfer data).
- W3C recommendation.
- No predefined tags.
- Extensible.
## Structure
- [A declaration/prolog (optional)](#declaration)
- [External stylesheet reference (optional)](#stylesheet).
- [A root element](#root) and its children.
### Declaration
```xml
<?xml version="1.0" encoding="UTF-8" standalone="..."?>
```
where:
- `standalone`: `yes|no` indicates no external dependencies required.
### Stylesheet
```xml
<?xml-stylesheet type="text/css" href="..."?>
```
where:
- `href`: the path to the `.css` file.
### Root
```xml
<root-name>
    ...
</root-name>
```
where:
- `root-name`: is the name of the root tag/element.
## Namespaces
Namespaces are often used to resolve the element/tag name conflict.
```xml
<prefix:element xmlns:prefix="uri">
</prefix:element>
```
where:
- `prefix`: a namespace identifier.
- `uri`: the corresponding URI (Uniform Resource Identifier) of the `prefix`.
### Examples
```xml
<h:table xmlns:h="http://www.w3.org/1999/xhtml">
    <h:caption>TABLE CAPTION</h:caption>
</h:table>
```
## Well-formedness
An XMl document must satisfy the following rules to achieve the well-formedness:
- Having a correct declaration.
- Having a root element.
- Every element must have opening and closing tags.
- Empty element must end with a `/` (forward dash).
- All attribute values must be surrounded by quotes.
## Validness
An XML document is valid when it's well-formed and passes all constraints of its corresponding schemas.
### XML Schema
#### Characteristics
- XML syntax.
- Datatype supporting.
## XML and JavaScript
- [XMLDOM]()
- [DOMParser](/language/formative/programming/js/built-in/objects/common/DOMParser)
- [AJAX (Asynchronous JavaScript And Xml)](/language/formative/programming/js/built-in/objects/common/XMLHttpRequest)
## Good practices
- Element for data and attribute for metadata.
## Comment
Comments can be single line or multilines.
```xml
<!-- ... -->

<!--
...
...
-->
```
# Markup Language
Markup languages are computer languages used to define the structure and/or presentation of content, normally in raw-text format. Popular markup languages are:
- [HTML](html)
- [XML](xml)
## Characteristics
- Tag base with attributes
- Hierarchical structure
## Markup tag
```xml
<tagName>...</tagName>
```
where:
- `tagName`: tag name
- `<tagName>`: opening tag
- `</tagName>`: closing tag
- `...`: tag content
### Empty tag
A markup tag that has no content.
```xml
<tagName />
```
## Attribute
- A name-value pairs are placed in opening tag.
- Attribute value **must** be enclosed in quotes `"`.
- Two attributes are separated by a space ` `.
```xml
<tagName attributeName="attributeValue">...</tagName>
```
```xml
<tagName attributeName1="attributeValue1" attributeName2="attributeValue2">...</tagName>
```

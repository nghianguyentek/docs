# HTML (HyperText Markup Language)
Like other markup languages, HTML is all about elements represented by tags and their attributes. Working with them, we
need to pay attention to their semantics and what attributes should be used especially required ones. Since HTML became
a standard, we should use validation tools such as the [W3C Markup Validation Service](https://validator.w3.org/) 
to ensure our documents are most compatibly.
- [A HTML document sample](#a-html-document-sample)
- [HTML Element](#html-element)
  - [Element attribute](#element-attribute)
    - [Common global attributes](#common-global-attributes)
  - [Element content](#element-content)
    - [Omitted](#omitted)
    - [Text content](#text-content)
    - [HTML content](#html-content)
## A HTML document sample
*You can copy the below codes into a file, for example, index.html, and open it in a browser to see the result.*
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width">
    <title>kihon.vn-Home</title>
</head>
<body>
<h1>Welcome to HTML world!</h1>
</body>
</html>
```
where
- `<!DOCTYPE html>` is a declaration to indicate this is an HTML5 document (the current version of HTML standard).
- `html`, `head`, `meta`, `title`, `body`, `h1` are HTML [elements](#html-element).
- `lang`, `charset` are element attribute.
- `kihon-vn-Home` and `Welcome to HTML world!` are element contents content.

You can imagine the structure of an HTML document like a tree. In the upper example, our tree is
- Document root
  - `DOCTYPE` document type declaration
  - `html` element
    - `head` element
      - `meta` charset
      - `meta` viewport
      - `title` element
    - `body` element
      - `h1` element
## HTML Element
An element in an HTML document is represented as an opening tag, a closing tag, and an inner content. For example,

`<title>kihon.vn-Hone<title>`
where
- `<title>` is the opening tag
- `</title>` is the closing tag
- `kihon.vn-Home` is the inner content between the opening and the closing tags.

In the opening tag, we can specify attributes of the element as you see

`<html lang="en">` which means we let the browser parser knows the language of our HTML document is `en` (English).

There are few elements (i.e., all other elements must have) who don't need the closing tag (because they don't need the inner content in general) 

`<meta charset="UTF-8">`

In general, pre-defined elements are enough for us to build our sites. However, in some specific (often advanced) cases, we need to create our own custom elements in the [JavaScript](/language/formative/programming/js) section.
## Element Attribute
Element attributes can be used to give more information about the element content and categorised into types:
- Built-in: attributes are defined in HTML specification and should be supported by browsers.
  - Global: attributes that all element has.
  - Specific: element-specific attributes.
- Custom: attributes are not defined in HTML specification.

In the below attribute setting,

`lang="en"`, 
- `lange` is the attribute name
- `en` is the attribute value which enclosed with double quotes.

We separate the name and value by the `=` sign. In the case of having more than one attribute, we add a space between two attributes. For example,

`<meta name="viewport" content="width=device-width">`
### Common global attributes

| Name  | Description                                     |
|:-----:|-------------------------------------------------|
|  id   | Element id that is used for JavaScript and CSS  |
| class | CSS classes to which this element belongs       |
| style | In-line stylesheet instructions of this element |

## Element Content
In HTML, an element content can be:
### Omitted
Content-omitted is often non-closing-tag elements or filled later by JavaScript.
For example,

`<meta charset="UTF-8">`
### Text content
Everything between the opening and the closing tags in text, except HTML tags. For examples:
- In the below case,
```html
<h1>Welcome to HTML world!</h1>
``` 
the text content of the `h1` element is 
```html
Welcome to HTML world!
```
- In the below case,
```html
<body>
    <h1>Welcome to HTML world!</h1>
</body>  
```
the text content of the `body` element is
```html

    Welcome to HTML world!

```
Note that there are some spaces (four in this case) at the beginning of `Welcome...` and two blank lines.
### HTML content
In the case the element text content contains other elements (aka nested element),  the deep level and relationships of tree nodes.
```html
<body>
    <h1>Welcome to HTML world!</h1>
</body>
```
In this case, the HTML content of the `body` element is
```html

    <h1>Welcome to HTML world!</h1>

```
which means `h1` is a child of `body` and `body` is the parent of `h1`.

In general, one element can appear many times inner another element (children or grandchildren). For example,
```html
...
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width">
  <title>Welcome to HTML world!</title>
</head>
...
```
as you see, `head` has two `meta` children. 

However, some are strictly one in the children case. For example, one HTML document can have only one child `html`, but it can contain other embedded documents and therefore can have many `html` grandchildren.

There is another case, when one element can't be a child of another element. For example, `meta` and `title` elements can't be in a
`body` element.
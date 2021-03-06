# HTML (HyperText Markup Language)
*You should read the [Web programming](/programming/web) before reading this.*

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
- [A simple document](#a-simple-document)
  - [Headings](#headings)
  - [Paragraph](#paragraph)
  - [Lists](#lists)
  - [Contextual text formatting](#contextual-text-formatting)
  - [Hyperlink](#hyperlink)
    - [Bookmark](#bookmark)
  - [Image](#image)
    - [Favicon](#favicon)
  - [Table](#table)
    - [Horizontal header](#horizontal-header)
    - [Horizontal & vertical headers](#horizontal--vertical-headers)
  - [Form](#form)
- Extensions
  - [Meta tag](meta.md)
## A HTML document sample
*You can copy the below codes into a file, for example, index.html, and open it in a browser to see the result.*
```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta name="description" content="kihon.vn home page">
    <meta name="keywords" content="kihon, kihon.vn">
    <meta name="author" content="kihon.vn">
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
- `kihon-vn-Home` and `Welcome to HTML world!` are element contents.

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

*Note:*

- *Although tag names are not case-sensitive, we often use the lower-case.*
- *In general, pre-defined elements are enough for us to build our sites. However, in some specific (often advanced) cases, we need to create our own custom elements in the [JavaScript](/language/formative/programming/js) section.*
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

*Note*

- *Same as tag name, attribute names should be in lower-case, though it isn't required.*
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
## A simple document
An HTML document like office document (e.g., Word or OpenOffice documents), has headings, paragraphs, lists, text formations, images, tables, and links.

*Note that if I didn't mention to the closing tag, it means they required.* 
### Headings
There are six heading levels from most important (and bigger) to less important (and smaller) in the descending order:
- `h1`: should appear one-per-document only.
- `h2`
- `h3`
- `h4`
- `h5`
- `h6`
- 
For example,
```html
<h1>This is a <code>h1</code> heading</h1>
<h2>This is a <code>h2</code> heading</h2>
<h3>This is a <code>h3</code> heading</h3>
<h4>This is a <code>h4</code> heading</h4>
<h5>This is a <code>h5</code> heading</h5>
<h6>This is a <code>h6</code> heading</h6>
```
### Paragraph
- `p`
```html
<p>A paragraph is a distinct section of writing covering one topic. 
  A paragraph will usually contain more than one sentence. 
  A typical paragraph will be 5-7 sentences, but this is by no means a rule. 
  The length is determined by the topic and the content.
</p>
```
### Lists
There are three listing types:
- Unordered list: `ul`
- Ordered list: `ol`
- Description list `dl`
Each list has one or more list items `li` as
```html
<ul>
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
</ul>
<ol>
  <li>Item 1</li>
  <li>Item 2</li>
  <li>Item 3</li>
</ol>
<dl>
  <dt>Item 1</dt>
  <dd>Item 1 description</dd>
  <dt>Item 2</dt>
  <dd>Item 2 description...</dd>
</dl>
```
Of course, we can create nested lists as
```html
<ol>
  <li>
    <h5>Item Type 1</h5>
    <ul>
      <li>Item 1</li>
      <li>Item 2</li>
      <li>Item 3</li>
    </ul>
  </li>
  <li>
    <h5>Item Type 2</h5>
    <dl>
      <dt lang="en-US"><dfn>Behavior</dfn></dt>
      <dt lang="en-GB"><dfn>Behaviour</dfn></dt>
      <dd>the way that someone behaves</dd>
      <dt>tick</dt>
      <dd>a very short time</dd>
      <dd>the sound clocks and watches make every second</dd>
    </dl>
  </li>
</ol>
```
### Contextual text formatting
Although we often use CSS for formatting and styling, HTML also supports some basic contextual text formatting elements:
- `strong` for important, serious (e.g., warning or caution), or urgent things.
- `small` for comments.
- `em` to emphasis.
- `mark` to mark or highlight for reference purposes.
- `sup` for superscripts.
- `sub` for subscripts.
- `s` (strikethrough) for no longer accurate or relevant things.
- `u` for misspelling words.
- `i` for alternative things such as other language sentences, a technical terms, etc.
- `q` for quotations.
- `cite` for titles or citations.
- `abbr` for abbreviations.
  - `title` attribute (required): full term or description
- `pre` (preformatted) to keep the format as we typed.
- `code` for a fragment of source code, is often used together with `pre`.
- `samp` for output samples.
- `kbd` (keyboard data) for keyboard key input.
- `time` for datetime data.
- `blockquote` for quoting more than one sentence.
  - `cite` attribute (required): attribute indicates the source.
- `bdo` (BiDirection Override)
  - `dir` attribute (required): direction
    - `ltr`: LeftToRight (default)
    - `rtl`: RightToLeft
### Semantic tags
- `section`
- `article`
- `aside`
### Hyperlink
We can use hyperlinks, `a` tags, to navigate to other documents (in the same site - relative path or different site - absolute path) and to another section in the same document (i.e., bookmark).
```html
<a href="https://google.com">Google</a>
<a href="https://google.com" target="_blank">Google</a><br>
```
where
- `href` attribute value contains the uri of the destination resource.
- `target` attribute value indicates how the browser will open the destination resource:
  - `_self`: default (not specified); open the destination resource in the same browser window/tab.
  - `_blank`: open the destination resource in a new window/tab.
#### Bookmark
In an HTML document, we can create bookmarks by using the `id` attribute.

*article1.htm*
```html
<h2 id="session2">Session 2</h2>
```
and create hyperlinks in the same or other documents to navigate to the upper section

*article1.htm*
```html
<a href="#session2">Session 2</a>
```
*article2.htm*
```html
<a href="article1.htm#session2">Session 2 of the Article 1</a>
```
### Image
To insert images into HTML documents, we use `img` tag.
```html
<img src="https://kihon.vn/img/thacbandoc.jpg" alt="Ban Doc waterfall">
```
where:
- `src`: both absolute or relative URI of the image.
- `alt`: the alternative text for screen reader and in the case, the client can't display the image.
#### Favicon
Favicon is the icon of your site/page, is right in the left of your page title on a browser tab. All modern browsers will automatically request favicon (`/favicon.ico` path) at the first time your site visited. 

Online sites to create favicon:
- [https://www.favicon.cc/](https://www.favicon.cc/)
#### Figure
A semantic element to provide caption for an image.
```html
<figure>
  <img src="https://kihon.vn/img/thacbandoc.jpg" alt="Ban Doc waterfall">
  <figcaption>Ban Doc waterfall</figcaption>
</figure>
```
### Table
#### Horizontal header
```html
<table>
  <caption>CAPTION</caption>
  <tr>
    <th>Column1 name</th>
    <th>Column2 Name</th>
  </tr>
  <tr>
    <td>Column1 of Row1 value</td>
    <td>Column2 of Row1 value</td>
  </tr>
  <tr>
    <td>Column1 of Row2 value</td>
    <td>Column2 of Row2 value</td>
  </tr>
</table>
```
where
- `tr`: table row
- `th`: column/row header
- `td`: table cell
#### Horizontal & Vertical headers
```html
<table>
  <caption>CAPTION</caption>
  <tr>
    <th></th>
    <th>Column1 name</th>
    <th>Column2 Name</th>
  </tr>
  <tr>
    <th>Row1 name</th>
    <td>Column1 of Row1 value</td>
    <td>Column2 of Row1 value</td>
  </tr>
  <tr>
    <th>Row2 name</th>
    <td>Column1 of Row2 value</td>
    <td>Column2 of Row2 value</td>
  </tr>
</table>
```
### Form
Form is used to collect user input for server-side processing later.
```html
<form method="post" action="/login">
  <label for="username">Username</label>
  <input id="username" name="username">
  <label for="password">Password</label>
  <input type="password" id="password" name="password">
  <input type="submit" value="Submit">
</form>
```
where
- `method` attribute: can be `post` or `get` [HTTP method](/network/protocol/file/http.md#methods)
- `action` attribute: the URI where the form data will be sent
#### Input
##### Common attributes
- `type`:
  - `text`: default (can be omitted)
  - `password`
  - `checkbox`: multiple choices
  - `radio`: single choice in multiple options
  - `select`: drop-down list
  - `submit`: button is used to submit the form
  - `number`: represents a numeric (default) or floating-point number based on the initialised value and step value
  - `range`
- `id`: for the corresponding `label`
- `name`: field/field group name in the form
- `value`: field value
##### Validating attributes
- `required`
- `minlength` and `maxlength`: for `text`, `textarea` types
- `min` and `max: for `number`, `range` types
- `pattern`: a regular expression
##### Types

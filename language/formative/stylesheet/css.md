# CSS (Cascading StyleSheets)
CSS determines how the content of HTML elements displayed.
[W3C CSS Validation Service](http://jigsaw.w3.org/css-validator/)
In an [HTML](/language/formative/markup/html) document, we can declare CSS in three ways:
- In-line: as value of the `style` attribute.
```html
<h1 style="color: blue;">This is a post heading</h1>
```
- Internal: as content of `<style>` elements, often are placed in `head` section.
```html
<head>
    <style>
        h1 {
            color: blue;
        }
    </style>
</head>

```
- External: in separate files and is included using the `link` elements in the `head` section.

*style.css*
```html
h1 {
    color: blue;
}
```
```html
<head>
    <link rel="stylesheet" href="style.css">
</head>
```
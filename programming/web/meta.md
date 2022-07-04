# meta element
## Declare link preview content
### Facebook Messenger, Instagram, and Zalo (Open Graph Protocol)
We should declare the `og` prefix in `html` tag
```html
<!DOCTYPE html>
<html lang="en" prefix="og: https://ogp.me/ns#">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <meta property="og:title" content="Meta tag">
    <meta property="og:type" content="website">
    <meta property="og:image" content="https://www.japanesewordswriting.com/wp-content/uploads/2016/11/kihon-h.jpg">
    <meta property="og:image:alt" content="Kihon-HTML-MetaTag">
    <meta property="og:url" content="https://kihon.vn/html/meta_tag">
    <title>Meta tag</title>
</head>
<body>
</body>
</html>
```
#### Required attributes
- `og:title`: title of your resource.
- `og:type`: type of your resource.
- `og:image`: the URI of the image represents your resource.
- `og:image:alt`: the alternative text for the image represents your resource.
- `og:url`: the URI of your resource.
#### Optional attributes
- `og:description`: one or two sentences to describe your resource.
- `og:locale`: your resource locale.
- `og:site_name`: your site name.
- `og:audio`: the URI of the audio to introduce your resource.
- `og:video`: the URI of the video to introduce your resource.
#### Debug links
- Facebook: *(Login required)* [Debug preview link](https://developers.facebook.com/tools/debug/) 
- Zalo: [Debug preview link](https://developers.zalo.me/tools/debug-sharing)

# HTTP (HyperText Transfer Protocol)
A HyperText is a document that contains links (aka hyperlinks) to other documents or specific sections in other documents.
## Characteristics
- Default port: `80`.
## URI
`http://domain_name[/path[#tag[?query]]]` where  
`path`: `path[/subpath][/file.extension]`,  
`query`: `key=value&key=value`
## Messages
### HTTP Request
- Request line
- Headers if any
- MIME body if any
#### Request line
- Method
- URI
- HTTP version
##### HTTP Methods
- GET
- POST
- PUT
- DELETE
- PATCH
##### HTTP Versions
- 1.0 (Deprecated)
- 1.1
- 2
- 3
#### A raw GET request example
```
GET / HTTP/1.1
Host: example.com
User-Agent: Mozilla/5.0
Accept: text/html,*/*
Accept-Language: en-US,en
Accept-Encoding: gzip,deflate
Connection: Keep-alive
```
### HTTP Response
- Status line
- Headers if any
- MIME body if any
#### Status line
- [HTTP version](#HTTP Versions): same as the request.
- Response code
- Response description  
Example: `HTTP/1.1 200 OK`
##### Response code
- 2xx: success
- 3xx: redirection
- 4xx: client error
- 5xx: server error
#### A raw HTTP Response example
```
HTTP/1.1 200 OK
Content-Encoding: gzip
Content-Type: text/html;charset=UTF-8
Date: Sun, 29 May 2022 13:19:58 GMT
Server: ECS (sab/5709)
Last-Modified: Thu, 17 Oct 2019 07:18:26 GMT
Content-Length: 648
[response_data]
```
## HTML document
### HTML tag
- A keyword enclosed with angle brackets.  
Example: `<tag></tag>`  
- Tag can have attributes and text content.  
Example: `<tag attribute_name="attribute_value>text_content</tag>`
### Structure
#### The \<html\> tag
The root tag of an HTML document that has two children:
- \<head\> tag
- \<body\> tag
#### The \<head\> tag
#### The \<body\> tag
#### Example
```html
<html>
<head>
    <title>document_title</title>
</head>
<body>
<h1>heading_1</h1>
<img src="img_uri" alt="alternative_text">
<ul>
    <li><a href="another_document_uri">another_document_title</a></li>
</ul>
</body>
</html>
```
## References
[]()
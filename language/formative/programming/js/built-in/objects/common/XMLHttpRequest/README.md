# XMLHttpRequest
## Properties
### readyState
Returns the current state of this XMLHttpRequest.

| Value               | Description                            |
|---------------------|----------------------------------------|
| **UNSENT**          |                                        |
| **OPENED**          | After [open()](#open) is successful.   |
| **HEADER_RECEIVED** | All response headers are received.     |
| **LOADING**         | Loading response body.                 |
| **DONE**            | Completed (both successful or failed). |

### status
The HTTP status code of the response.
### responseText
Returns the response data as a text with UTF-8 charset by default.
### responseXML
Returns the response data as an XML Document object.
## Methods
### open
```
open(httpMethod, targetURL);
```
where:
- `httpMethod`: `GET|POST`.
### setRequestHeader
*Must be called after [open](#open)*
```
setRequestHeader(httpHeaderName, httpHeaderValue);
```
### send
*Must be called after [open](#open)*
```
send(data);
```
where:
- `data`: type of `String|URLSearchParams|FormData|Document|BufferSource|Blob`.
### getResponseHeader
```
httpHeaderValue getResponseHeader(httpHeaderName);
```
## Example
```js
const req = new XMLHttpRequest();
const reqData = {};

req.onreadystatechange = onsuccess;
function onsuccess() {
    if (req.readyState === XMLHttpRequest.DONE && req.status === 200) {
        // TODO: update something with req.resonseText or req.responseXML
    }
}

req.open('GET', url);
req.setRequestHeader('content-type', 'application/json;charset=utf-8');
req.send(reqData);
```

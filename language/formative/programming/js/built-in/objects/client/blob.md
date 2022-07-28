# Blob
A byte sequence.
- Properties
  - `unsigned long size`: blob size.
  - `string type`: blob MIME type.
- Methods
  - `Promise<String> text()`: encodes this Blob to an UTF-8 String.